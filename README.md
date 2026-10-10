# nvim

Personal Neovim config (Neovim 0.12+), started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

Requirements: `git`, `make`, a C compiler, `ripgrep`, `fd`, a Nerd Font, Java 21+ for jdtls (Java projects may target older JDKs).

```sh
git clone <this repo> ~/.config/nvim
nvim   # lazy.nvim installs plugins, Mason installs language servers and formatters
```

- `init.lua` → `lua/config/` (options, keymaps, autocmds, plugin manager)
- `lua/plugins/` → one file per area (lsp, completion, telescope, editor, ...)
- `ftplugin/java.lua` → jdtls setup and Java refactor/generate keymaps
