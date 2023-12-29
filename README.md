# nvim

Currently using the version specified in the [.tool-versions](./.tool-versions) file.

Using [`asdf`](https://github.com/asdf-vm/asdf) as the neovim version manager and [lazy.nvim](https://) as the plugin manager.

## Gallery

<img width="812" alt="Neovim dashboard" src="https://github.com/ismailshak/nvim/assets/23173408/bdd6c244-a663-438f-83fe-c9c0dfdf5d65">

<details><summary>Expand for more</summary>
  
  <p>
    <img width="812" alt="Autocomplete and diagnostics" src="https://github.com/ismailshak/nvim/assets/23173408/1edbb296-79d2-4889-95a7-6e6a34f31a09">
    <img width="812" alt="LSP progress spinner" src="https://github.com/ismailshak/nvim/assets/23173408/960ede2e-bf75-4c2d-abed-70f8d5cc560b">
    <img width="812" alt="Git diff" src="https://github.com/ismailshak/nvim/assets/23173408/e8394b61-e8fd-4cca-ad64-c8a6fbce7f61">
    <img width="812" alt="File picker" src="https://github.com/ismailshak/nvim/assets/23173408/09fc9f3c-ae59-453d-8c29-37e5f629b6fa">
  </p>

</details>

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

`mason.nvim` will install LSPs, linters & formatters. Some tools are required for it to do so.

### Required

- `wget`
- `node`
- `python3`
- `go`
- `rustup`
- `make`
- `gcc` or `clang`
- `fzf`
- `fd`
- `rg`
- `dark-mode` (macOS only)

### Optional

- `bat`
- `delta`

