-- ╭──────────────────────────────────────────────────────────╮
-- │ Plugins                                                  │
-- ╰──────────────────────────────────────────────────────────╯

lvim.plugins = {
  -- Themes
  { "dracula/vim" },
  { "pineapplegiant/spaceduck" },
  { 'karb94/neoscroll.nvim' },
  { 'Mofiqul/vscode.nvim' },
  { 'sainnhe/sonokai' },
  { 'bluz71/vim-nightfly-guicolors' },
  { 'marko-cerovac/material.nvim' },
  { "folke/tokyonight.nvim" },
  { "elixir-editors/vim-elixir" },
  { "tanvirtin/monokai.nvim" },
  { "NLKNguyen/papercolor-theme" },
  {
    "olimorris/onedarkpro.nvim",
    theme = "onedark_dark"
  },
  { "altercation/vim-colors-solarized" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  -- Utilities
  { 'andweeb/presence.nvim' },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Copilot
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      prompts = {
        Rename = {
          prompt = "Please rename the variable correctly in give selection based on context",
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source)
          end
        }
      }
    },
  },

  -- Linting and formatting
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          -- null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.diagnostics.write_good,
          null_ls.builtins.code_actions.gitsigns,
        }
      })
    end
  },

  -- UI enhancements
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      routes = {
        {
          view = "cmdline_popup",
          filter = { event = "msg_show", find = "Select a", },
          opts = { enter = true, skip = true },
        },
      },
      presets = {
        command_palette = false,
        long_message_to_split = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  },
}
