# nvim

## Binaries needed

```bash
brew install stylua codespell
```

```bash
go install golang.org/x/tools/cmd/goimports@latest
```

Make sure you have go's bin dir on your PATH: `export PATH="$PATH:$HOME/go/bin"`

## LSPs installed

```vim
:LspInstall cssls gopls jsonls tsserver html dockerls sumneko_lua marksman yamlls
```

