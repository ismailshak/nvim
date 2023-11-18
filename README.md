# nvim

Currently using the version specified in the [.tool-versions](./.tool-versions) file.

Using [`asdf`](https://github.com/asdf-vm/asdf) as my neovim version manager.


# Setup

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
- `dark-mode`

### Optional

- `bat`
- `delta`

