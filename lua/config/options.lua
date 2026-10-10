local o = vim.o

o.number = true
o.relativenumber = true
o.mouse = 'a'
o.showmode = false -- shown in the statusline instead

-- Sync with the system clipboard (scheduled to avoid slowing startup)
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split' -- live preview of :s substitutions
o.cursorline = true
o.scrolloff = 10
o.confirm = true -- ask to save instead of failing on :q with unsaved changes
o.winborder = 'rounded' -- borders on floating windows (hover, diagnostics, ...)
