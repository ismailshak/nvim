# nvim

<p align="center">
  <img width="812" alt="Neovim dashboard" src="https://github.com/ismailshak/nvim/assets/23173408/bdd6c244-a663-438f-83fe-c9c0dfdf5d65">
</p>

<details><summary>More pics</summary>
  <p><sub>Customized <a href="https://wezfurlong.org/wezterm/index.html">Wezterm</a> - Modified <a href="https://cocopon.github.io/iceberg.vim/">Iceberg</a> - Modified & nerd-font-patched <a href="https://commitmono.com/">Commit Mono</a></sub></p>

  <p align="center">
    <img width="812" alt="LSP progress spinner" src="https://github.com/ismailshak/nvim/assets/23173408/960ede2e-bf75-4c2d-abed-70f8d5cc560b">
    <img width="812" alt="Git diff" src="https://github.com/ismailshak/nvim/assets/23173408/c29c9482-e63c-4f3c-9feb-f503db1f1a6d">
    <img width="812" alt="Autocomplete and diagnostics" src="https://github.com/ismailshak/nvim/assets/23173408/75ee8ee1-673f-4d76-bb50-35b5cdae6987">
    <img width="812" alt="Terminal" src="https://github.com/ismailshak/nvim/assets/23173408/1380ab8e-6b4b-49e8-9a74-44dd71914006">
  </p>
</details>

<br />

Currently using the version specified in the [mise.toml](./mise.toml) file.

Using [`mise`](https://github.com/jdx/mise) as the neovim version manager and [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Setup

Run the following from the repo root to install and set the neovim version globally

```bash
mise run global
```

## Tools needed

`mason.nvim` will install LSPs, linters & formatters. Some tools are required for it to do so. Other tools are needed to enhance plugin capabilities.

### Required

- `fzf`
- `gcc` or `clang`
- `make`
- `node`
- `python3`
- `rg`
- `tree-sitter`
- `wget`

### Optional

- `bat`
- `delta`
- `fd`
- `gh`

## Language support

Bash, CSS, Docker, HTML, JSON, Lua, Markdown and YAML work out of the box. Other languages are supported but need extra steps:

<details>
<summary>C/C++</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall clangd clang-format codelldb`

<h3>Manual</h3>

Or using your package manager of choice, install the following and make sure they're on your `$PATH`:

- `clangd` (language server)
- `clang-format` (formatter)
- `codelldb` (debugger, optional)

</details>

<details>
<summary>Elixir</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall elixir-ls`

<h3>Manual</h3>

Or install it with your method of choice and make sure it's on your `$PATH`:

- `elixir-ls` (language server)

</details>

<details>
<summary>Go</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall gopls goimports golangci-lint delve`

<h3>Manual</h3>

Or install go using your method of choice. Then you'll need to install the following:

- `gopls` (language server)

```bash
go install golang.org/x/tools/gopls@latest
```

- `goimports` (formatter, same as `gofmt` but also organizes imports)

```bash
go install golang.org/x/tools/cmd/goimports@latest
```

- `golangci-lint` (linter, optional)

```bash
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
```

- `delve` (debugger, optional)

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

Since `$GOPATH` should already be on your `$PATH`, no more configuration is needed

</details>

<details>
<summary>GraphQL</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall graphql-language-service-cli`

<h3>Manual</h3>

Or install it with npm and make sure it's on your `$PATH`:

- `graphql-lsp` (language server, from the `graphql-language-service-cli` package)

Formatting uses the project's `prettier`, see the JavaScript/TypeScript section.

</details>

<details>
<summary>JavaScript/TypeScript</summary>

<h3>Installer</h3>

mason.nvim installs `vtsls`, `eslint` and `js-debug-adapter` on its own. For Tailwind projects, you can run the command `:MasonInstall tailwindcss-language-server`

<h3>Manual</h3>

TypeScript and prettier come from the project's package.json:

```bash
pnpm install -D typescript prettier
```

- `tsc --lsp` (language server) is used when the project's TypeScript is 7 or later
- `vtsls` (language server) is used when the project's TypeScript is 5 or 6. It bundles its own TypeScript. Only one of the two attaches per project.
- `prettier` (formatter). The project's `node_modules` copy is used. One on your `$PATH` works as a fallback for files outside a project.
- `eslint` (linter). Also covers JSON, Markdown, Svelte and Vue files.
- `js-debug-adapter` (debugger). Node and Chrome launch configurations are built in, and `.vscode/launch.json` entries are picked up.
- `tailwindcss-language-server` (language server, optional).

`:OrganizeImports` runs the organize imports code action with whichever server is attached.

</details>

<details>
<summary>OCaml</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall ocaml-lsp ocamlformat`

<h3>Manual</h3>

Or using your package manager of choice, install [`opam`](https://opam.ocaml.org/). Then run the following commands:

- Initialize internals

```bash
opam init
```

- Install LSP and formatter

```bash
opam install -y ocaml-lsp-server ocamlformat
```

The path to packages should be automatically added to your `$PATH`, so no more configuration needed

</details>

<details>
<summary>Rust</summary>

<h3>Installer</h3>

Using mason.nvim, you'll just install a debugger (optional). `:MasonInstall codelldb`

<h3>Manual</h3>

Install [`rustup`](https://www.rust-lang.org/tools/install) using the method of your choosing. Then run the following commands:

- Add `rust_analyzer` (language server)

```bash
rustup component add rust-analyzer
```

- Add `rustfmt` (formatter)

```bash
rustup component add rustfmt
```

- Add `clippy` (linter)

```bash
rustup component add clippy
```

The `rustup` installation should automatically handle updating your `$PATH`, so no more configuration needed

</details>

<details>
<summary>SQL</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall sql-formatter`

<h3>Manual</h3>

Or install it with your package manager of choice and make sure it's on your `$PATH`:

- `sql-formatter` (formatter)

</details>

<details>
<summary>Svelte</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall svelte-language-server`

<h3>Manual</h3>

Or install it with your package manager of choice and make sure it's on your `$PATH`:

- `svelteserver` (language server, from the `svelte-language-server` package)

Formatting uses the project's `prettier`, see the JavaScript/TypeScript section.

</details>
