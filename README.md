# nvim

<p align="center">
<img width="812" alt="Neovim dashboard" src="https://github.com/ismailshak/nvim/assets/23173408/bdd6c244-a663-438f-83fe-c9c0dfdf5d65">
</p>


<details><summary>Expand for more pics</summary>

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

```shell
asdf plugin add https://github.com/richin13/asdf-neovim
```

Install the version in the file

```
asdf install
```

Set the version globally

```
asdf global neovim $(cat .tool-versions | awk '/neovim/ {print $2}')
```

## Tools needed

`mason.nvim` will install LSPs, linters & formatters. Some tools are required for it to do so. Other tools are needed to enhance plugin capabilities.

### Required

- `fzf`
- `gcc` or `clang`
- `go`
- `make`
- `node`
- `python3`
- `rg`
- `stylua`
- `wget`

### Optional

- `bat`
- `delta`
- `fd`

