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

Currently using the version specified in the [.tool-versions](./.tool-versions) file.

Using [`asdf`](https://github.com/asdf-vm/asdf) as the neovim version manager and [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Setup

Following is executed from this repo's root directory.

Install the plugin

```bash
asdf plugin add https://github.com/richin13/asdf-neovim
```

Install the version in the file

```bash
asdf install
```

Set the version globally

```bash
asdf global neovim $(cat .tool-versions | awk '/neovim/ {print $2}')
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
- `wget`
- `gh`

### Optional

- `bat`
- `delta`
- `fd`

## Language Support

By default, the following languages and file types will work out of the box

- Bash
- Dockerfile
- JavaScript/TypeScript (+ HTML/CSS)
- JSON
- Lua
- Markdown
- YAML

Below is a list of expandable sections detailing what's needed in order to enable other supported languages

<details>
<summary>C/C++</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall clangd clang-format codelldb`.

<h3>Manual</h3>

Or using your system's package manager, install the following and make sure they're on your `$PATH`:

- `clangd`
- `clang-format`
- `codelldb` (debugger, optional)

</details>

<details>
<summary>Go</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall gopls goimports delve`

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

- `delve` (debugger, optional)

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
  ```

Since `$GOPATH` should already be on your `$PATH`, no more configuration is needed

</details>

<details>
<summary>OCaml</summary>

<h3>Installer</h3>

Using mason.nvim, you can run the command `:MasonInstall ocaml-lsp ocamlformat`

<h3>Manual</h3>

Or using your system's package manager, install [`opam`](https://opam.ocaml.org/). Then run the following commands:

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
