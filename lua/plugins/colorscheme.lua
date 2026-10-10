return {
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000, -- load before other start plugins
    config = function()
      require('github-theme').setup {}
      vim.cmd.colorscheme 'github_dark'
    end,
  },

  -- Alternatives, loaded on demand: try them with <leader>sc
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true, opts = { styles = { comments = { italic = false } } } },
}
