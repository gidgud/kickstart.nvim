local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup('user-config', { clear = true })

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd('BufReadPost', {
  desc = 'Restore cursor to its last position when reopening a file',
  group = group,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == 'gitcommit' or ft == 'gitrebase' then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd('VimResized', {
  desc = 'Equalize splits when the terminal is resized',
  group = group,
  command = 'tabdo wincmd =',
})
