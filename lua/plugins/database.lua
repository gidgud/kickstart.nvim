-- Database client (replaces DataGrip): vim-dadbod + UI + completion.
-- Add a connection with `A` in the drawer (e.g. postgres://user:pass@localhost:5432/db);
-- it's saved to stdpath('data')/db_ui, outside this repo.
return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>D', '<cmd>DBUIToggle<CR>', desc = '[D]atabase UI' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui'
      vim.g.db_ui_execute_on_save = 0 -- run queries with <leader>S, not on every save
      vim.g.db_ui_show_database_icon = 1
    end,
  },

  -- Table/column completion in SQL buffers
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        per_filetype = {
          sql = { 'dadbod', 'snippets', 'buffer' },
          mysql = { 'dadbod', 'snippets', 'buffer' },
          plsql = { 'dadbod', 'snippets', 'buffer' },
        },
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
  },
}
