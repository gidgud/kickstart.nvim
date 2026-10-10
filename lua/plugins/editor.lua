return {
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- detect tabstop and shiftwidth automatically

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      -- nvim-tree replaces netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'File [E]xplorer' },
    },
    opts = {
      update_focused_file = { enable = true }, -- highlight the current file in the tree
    },
  },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Jump to next git [c]hange')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Jump to previous git [c]hange')

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'git [s]tage hunk')
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'git [r]eset hunk')
        map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage hunk')
        map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
        map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
        map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
        map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
        map('n', '<leader>hb', gitsigns.blame_line, 'git [b]lame line')
        map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, 'git [D]iff against last commit')
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git [b]lame line')
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, '[T]oggle git show [D]eleted')
      end,
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>cg', group = '[G]enerate' },
        { '<leader>cr', group = '[R]efactor' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 } -- better around/inside textobjects
      require('mini.surround').setup() -- sa/sd/sr: add/delete/replace surroundings

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
