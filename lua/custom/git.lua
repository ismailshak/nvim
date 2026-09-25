---Git queries and GitHub links for the repository a buffer's file is in. Results go to a callback on the main loop,
---so the callback can use the editor API. Anything that fails is reported with vim.notify and the callback is not
---called.
local M = {}

---Runs git in `cwd` and calls `cb` with the finished process. Stdout and stderr are trimmed.
---@param cwd string
---@param args string[]
---@param cb fun(out: vim.SystemCompleted)
---@param stdin string[]? lines written to git's stdin
local function run(cwd, args, cb, stdin)
	local cmd = vim.list_extend({ "git" }, args)
	vim.system(cmd, { cwd = cwd, text = true, stdin = stdin }, function(out)
		out.stdout = vim.trim(out.stdout or "")
		out.stderr = vim.trim(out.stderr or "")
		vim.schedule(function()
			cb(out)
		end)
	end)
end

---Runs git in `cwd` and calls `cb` with its stdout
---@param cwd string
---@param args string[]
---@param cb fun(stdout: string)
---@param stdin string[]?
local function query(cwd, args, cb, stdin)
	run(cwd, args, function(out)
		if out.code ~= 0 then
			local message = out.stderr ~= "" and out.stderr or ("git " .. table.concat(args, " ") .. " failed")
			vim.notify(message, vim.log.levels.ERROR)
			return
		end
		cb(out.stdout)
	end, stdin)
end

---@class custom.git.Remote
---@field host string github.com, or a GitHub Enterprise host
---@field owner string
---@field repo string without the .git suffix
---@field url string https URL of the repository's page, with no trailing slash

---Handles git@host:owner/repo.git, ssh://git@host/owner/repo.git and https://host/owner/repo.git. Returns nil for
---anything else, such as a local path.
---@param url string
---@return custom.git.Remote?
function M.parse_remote_url(url)
	local host, path = url:match("^[%w%.%-_]+@([^:/]+):(.+)$")
	if not host then
		local rest = url:match("^%a[%w+.-]*://(.+)$")
		if not rest then
			return nil
		end
		rest = rest:gsub("^[^/@]*@", "")
		host, path = rest:match("^([^/:]+):?%d*/(.+)$")
	end
	if not host then
		return nil
	end

	path = path:gsub("^/+", ""):gsub("/+$", ""):gsub("%.git$", "")
	local owner, repo = path:match("^(.+)/([^/]+)$")
	if not owner then
		return nil
	end

	return { host = host, owner = owner, repo = repo, url = string.format("https://%s/%s/%s", host, owner, repo) }
end

---Calls `cb` with the parsed URL of the origin remote
---@param cwd string
---@param cb fun(remote: custom.git.Remote)
function M.remote(cwd, cb)
	query(cwd, { "remote", "get-url", "origin" }, function(url)
		local remote = M.parse_remote_url(url)
		if not remote then
			vim.notify("Cannot build a web URL from the origin remote " .. url, vim.log.levels.ERROR)
			return
		end
		cb(remote)
	end)
end

---@param cwd string
---@param cb fun(sha: string)
function M.head(cwd, cb)
	query(cwd, { "rev-parse", "HEAD" }, cb)
end

---@class custom.git.Commit
---@field sha string full sha
---@field subject string

---`rev` can be anything git rev-parse accepts, such as a short sha or a tag
---@param cwd string
---@param rev string
---@param cb fun(commit: custom.git.Commit)
function M.commit(cwd, rev, cb)
	-- git log rather than git show, because git show prints an annotated tag's own message before the commit
	query(cwd, { "log", "-1", "--format=%H%x09%s", rev }, function(out)
		local sha, subject = out:match("^(%x+)\t(.*)$")
		cb({ sha = sha, subject = subject })
	end)
end

---The buffer's text is blamed, not the file on disk, so the line number matches the cursor when the buffer has
---unsaved changes
---@param buf integer
---@param line integer 1-based
---@param cb fun(sha: string)
function M.blame_line(buf, line, cb)
	local file = vim.api.nvim_buf_get_name(buf)
	local range = string.format("%d,%d", line, line)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local args = { "blame", "--porcelain", "-L", range, "--contents", "-", "--", file }
	query(vim.fs.dirname(file), args, function(out)
		local sha = out:match("^(%x+) ")
		if not sha or sha:match("^0+$") then
			vim.notify(string.format("Line %d is not committed yet", line), vim.log.levels.WARN)
			return
		end
		cb(sha)
	end, lines)
end

---Calls `cb` with the merge commit on HEAD's first-parent chain that merged `sha`, or nil when `sha` is on the chain
---itself. It is on the chain after a squash merge, a rebase merge or a direct commit.
---
---The merge is the oldest commit that is both a descendant of `sha` and on the first-parent chain. The oldest merge
---that descends from `sha` would be wrong when the branch had merges of its own, such as main merged into it.
---@param cwd string
---@param sha string full sha
---@param cb fun(merge: custom.git.Commit?)
function M.merge_into_head(cwd, sha, cb)
	local range = sha .. "..HEAD"
	query(cwd, { "rev-list", "--first-parent", range }, function(first_parent_out)
		local on_first_parent_chain = {}
		for commit in first_parent_out:gmatch("%x+") do
			on_first_parent_chain[commit] = true
		end

		local args = { "log", "--reverse", "--ancestry-path", "--format=%H %P%x09%s", range }
		query(cwd, args, function(log)
			for entry in vim.gsplit(log, "\n", { trimempty = true }) do
				local hashes, subject = entry:match("^([%x ]+)\t(.*)$")
				local commit, first_parent = hashes:match("^(%x+) ?(%x*)")
				if on_first_parent_chain[commit] then
					if first_parent == sha then
						cb(nil)
					else
						cb({ sha = commit, subject = subject })
					end
					return
				end
			end
			cb(nil)
		end)
	end)
end

---Calls `cb` with the file's path relative to the repository root
---@param cwd string
---@param file string absolute path
---@param cb fun(path: string)
function M.tracked_path(cwd, file, cb)
	query(cwd, { "ls-files", "--full-name", "--", file }, function(path)
		if path == "" then
			vim.notify("File is not tracked by git", vim.log.levels.WARN)
			return
		end
		cb(path)
	end)
end

---`pushed` is whether HEAD is an ancestor of the upstream branch. `reason` is the message to show when it is not.
---@param cwd string
---@param cb fun(pushed: boolean, reason: string?)
function M.head_pushed(cwd, cb)
	run(cwd, { "merge-base", "--is-ancestor", "HEAD", "@{upstream}" }, function(out)
		if out.code == 0 then
			cb(true)
		elseif out.code == 1 then
			cb(false, "HEAD has not been pushed to the upstream branch")
		else
			cb(false, "The current branch has no upstream branch")
		end
	end)
end

---@param cwd string
---@param file string absolute path
---@param cb fun(changed: boolean)
function M.changed_since_head(cwd, file, cb)
	run(cwd, { "diff", "--quiet", "HEAD", "--", file }, function(out)
		cb(out.code ~= 0)
	end)
end

---@param buf integer
---@return string?
local function buf_file(buf)
	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		vim.notify("Buffer has no file", vim.log.levels.WARN)
		return nil
	end
	return file
end

---The pull request number in a squash merge subject, "Add thing (#12)", or a merge commit subject, "Merge pull
---request #12 from owner/branch"
---@param subject string
---@return string?
local function pull_request_number(subject)
	return subject:match("%(#(%d+)%)$") or subject:match("^Merge pull request #(%d+)")
end

---@param url string
local function open_url(url)
	local _, err = vim.ui.open(url)
	if err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end

---@param cwd string
---@param sha string
---@param cb fun(url: string)
local function pull_request_url_from_github(cwd, sha, cb)
	local short = sha:sub(1, 7)
	if vim.fn.executable("ghs") ~= 1 then
		local message = string.format("No pull request found for %s in git history, and gh is not installed", short)
		vim.notify(message, vim.log.levels.WARN)
		return
	end

	vim.notify("Asking GitHub for the pull request containing " .. short, vim.log.levels.INFO)
	-- gh fills in {owner} and {repo} from the origin remote of cwd
	local endpoint = string.format("repos/{owner}/{repo}/commits/%s/pulls", sha)
	vim.system({ "gh", "api", endpoint, "--jq", ".[0].html_url" }, { cwd = cwd, text = true }, function(out)
		vim.schedule(function()
			if out.code ~= 0 then
				vim.notify(vim.trim(out.stderr), vim.log.levels.ERROR)
			elseif vim.trim(out.stdout) == "" then
				vim.notify("No pull request found for " .. short, vim.log.levels.WARN)
			else
				cb(vim.trim(out.stdout))
			end
		end)
	end)
end

---Calls `cb` with the URL of the pull request that merged a commit into HEAD. The number is read from the subject of
---the merge commit on HEAD's first-parent chain, or from the commit's own subject when the commit is on the chain
---itself. GitHub is asked when that subject has no number.
---
---The merge commit is read first because a commit's own subject can name a pull request in another repository or in
---a branch. That happens when a repository's history is merged into a monorepo, and with stacked pull requests.
---@param buf integer the buffer whose file is in the repository
---@param rev string? a commit, or nil to blame the cursor line
---@param cb fun(url: string)
function M.pull_request_url(buf, rev, cb)
	local file = buf_file(buf)
	if not file then
		return
	end
	local cwd = vim.fs.dirname(file)

	local function from_number(number)
		M.remote(cwd, function(remote)
			cb(string.format("%s/pull/%s", remote.url, number))
		end)
	end

	local function find(commit_rev)
		M.commit(cwd, commit_rev, function(commit)
			M.merge_into_head(cwd, commit.sha, function(merge)
				local number = pull_request_number((merge or commit).subject)
				if number then
					from_number(number)
				else
					pull_request_url_from_github(cwd, commit.sha, cb)
				end
			end)
		end)
	end

	if rev then
		vim.notify("Finding the pull request for " .. rev, vim.log.levels.INFO)
		find(rev)
	else
		local line = vim.fn.line(".")
		vim.notify(string.format("Finding the pull request for line %d", line), vim.log.levels.INFO)
		M.blame_line(buf, line, find)
	end
end

---@param buf integer
---@param rev string? a commit, or nil to blame the cursor line
function M.open_pull_request(buf, rev)
	M.pull_request_url(buf, rev, open_url)
end

---@param buf integer
---@param rev string? a commit, or nil to blame the cursor line
function M.yank_pull_request(buf, rev)
	M.pull_request_url(buf, rev, function(url)
		vim.fn.setreg("+", url)
		vim.notify("Copied " .. url, vim.log.levels.INFO)
	end)
end

---Copies a GitHub link to lines of the buffer's file at HEAD's commit to the + register. The link is copied even when
---HEAD is not pushed or the file has changed since HEAD. The notification says so, because the link is then dead or
---points at other lines.
---@param buf integer
---@param first integer 1-based first line
---@param last integer 1-based last line, equal to `first` for a single line
function M.yank_permalink(buf, first, last)
	local file = buf_file(buf)
	if not file then
		return
	end
	local cwd = vim.fs.dirname(file)
	local lines = first == last and string.format("#L%d", first) or string.format("#L%d-L%d", first, last)

	M.remote(cwd, function(remote)
		M.head(cwd, function(sha)
			M.tracked_path(cwd, file, function(path)
				local url = string.format("%s/blob/%s/%s%s", remote.url, sha, path, lines)
				vim.fn.setreg("+", url)

				M.head_pushed(cwd, function(pushed, reason)
					M.changed_since_head(cwd, file, function(changed)
						local warnings = {}
						if not pushed then
							table.insert(warnings, reason)
						end
						if changed or vim.bo[buf].modified then
							table.insert(warnings, "File has changes since HEAD, line numbers may be off")
						end

						local level = #warnings == 0 and vim.log.levels.INFO or vim.log.levels.WARN
						table.insert(warnings, 1, "Copied " .. url)
						vim.notify(table.concat(warnings, "\n"), level)
					end)
				end)
			end)
		end)
	end)
end

return M
