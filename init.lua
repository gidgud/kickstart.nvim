-- Leader must be set before plugins load so their mappings use it
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to false if your terminal isn't using a Nerd Font
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
