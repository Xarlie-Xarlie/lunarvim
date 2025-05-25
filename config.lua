-- ╭──────────────────────────────────────────────────────────╮
-- │ Leader Key                                               │
-- ╰──────────────────────────────────────────────────────────╯
lvim.leader = "space"

-- ╭──────────────────────────────────────────────────────────╮
-- │ Buffer Motions                                           │
-- ╰──────────────────────────────────────────────────────────╯
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- ╭──────────────────────────────────────────────────────────╮
-- │ Terminals                                                │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.terminal.execs = {
  { vim.o.shell, "<C-1>", "Horizontal Terminal", "horizontal", 0.5 },
  { vim.o.shell, "<C-2>", "Vertical Terminal",   "vertical",   0.5 },
  { vim.o.shell, "<C-3>", "Float Terminal",      "float",      nil }
}

-- ╭──────────────────────────────────────────────────────────╮
-- │ Telescope Config                                         │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.telescope.defaults = {
  layout_strategy = "horizontal",
  layout_config = {
    height = 0.95,
    width = 0.95,
    prompt_position = "bottom",
    vertical = {
      mirror = true,
      preview_cutoff = 0,
    },
  },
}


function CustomQuickChat()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").buffer
    })
  end
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Telescope custom livegrep                                │
-- ╰──────────────────────────────────────────────────────────╯
function CustomLiveGrep()
  local include_glob = vim.fn.input("Include Glob (e.g., '*.ex* *.lock*'): ")
  local exclude_glob = vim.fn.input("Exclude Glob (e.g., '*.exs* *.tmp*'): ")

  local glob_pattern = {}

  for pattern in include_glob:gmatch("%S+") do
    table.insert(glob_pattern, pattern)
  end

  for pattern in exclude_glob:gmatch("%S+") do
    table.insert(glob_pattern, "!" .. pattern)
  end
  print("Glob Pattern: " .. vim.inspect(glob_pattern))

  require("telescope.builtin").live_grep({ glob_pattern = glob_pattern })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Custom Run Tests in buffer                               │
-- ╰──────────────────────────────────────────────────────────╯
local jest_window = nil
local jest_buffer = nil

function ToggleJestFloatingWindow()
  if jest_window and vim.api.nvim_win_is_valid(jest_window) then
    vim.api.nvim_win_close(jest_window, true)
    jest_window = nil
    return
  end

  if not jest_buffer or not vim.api.nvim_buf_is_valid(jest_buffer) then
    jest_buffer = vim.api.nvim_create_buf(false, true)
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  }
  jest_window = vim.api.nvim_open_win(jest_buffer, true, opts)
end

function RunJestInFloatingWindow(current_file)
  if not jest_window or not vim.api.nvim_win_is_valid(jest_window) then
    ToggleJestFloatingWindow()
  end

  if not jest_buffer or not vim.api.nvim_buf_is_valid(jest_buffer) then
    jest_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(jest_window, jest_buffer)
  end

  local file_extension = vim.fn.fnamemodify(current_file, ":e")

  local cmd
  if file_extension == "exs" then
    cmd = "mix test " .. current_file
  elseif file_extension == "js" then
    cmd = "npm test " .. current_file
  else
    vim.api.nvim_buf_set_lines(jest_buffer, 0, -1, false, { "Unsupported file type: " .. current_file })
    return
  end

  vim.api.nvim_buf_set_lines(jest_buffer, 0, -1, false,
    { "Running tests...", "Current file: " .. current_file, "Command: " .. cmd })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, data)
      end
    end,
    on_exit = function()
      vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, { "", "Test run completed." })
    end,
  })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Custom KeyMappings                                       │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.which_key.mappings["s"].T = { ":lua CustomLiveGrep()<CR>", "Custom Live Grep" }
lvim.builtin.which_key.mappings["t"] = {
  name = "Quick Test",
  t = { ":lua RunJestInFloatingWindow(vim.fn.expand('%'))<CR>", mode = "n", "Run Jest in floating window" },
  f = { ":lua ToggleJestFloatingWindow()<CR>", mode = "n", "Toggle Jest floating window" },
}
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope find_files<CR>", "Find files" }
lvim.builtin.which_key.mappings["z"] = {
  name = "CopilotChat",
  c = { ":CopilotChat<CR>", mode = "n", "Chat with Copilot" },
  q = { ":lua CustomQuickChat()<CR>", mode = "n", "Quick Chat with Copilot" },
  e = { ":CopilotChatExplain<CR>", mode = "v", "Explain Code" },
  r = { ":CopilotChatReview<CR>", mode = "v", "Review Code" },
  f = { ":CopilotChatFix<CR>", mode = "v", "Fix Code Issues" },
  o = { ":CopilotChatOptimize<CR>", mode = "v", "Optimize Code" },
  d = { ":CopilotChatDocs<CR>", mode = "v", "Generate Docs" },
  t = { ":CopilotChatTests<CR>", mode = "v", "Generate Tests" },
  m = { ":CopilotChatCommit<CR>", mode = "n", "Generate Commit Message" },
  n = { ":CopilotChatRename<CR>", mode = "v", "Rename the variable" },
  s = { ":CopilotChatSave ", mode = "n", "Save the history" },
  l = { ":CopilotChatLoad ", mode = "n", "Load the history" },
}

-- ╭──────────────────────────────────────────────────────────╮
-- │ Default Lunavim Configs                                  │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.setup.filters.dotfiles = false
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "catppuccin"
lvim.transparent_window = true

-- ╭──────────────────────────────────────────────────────────╮
-- │ Default Vim Configs                                      │
-- ╰──────────────────────────────────────────────────────────╯
vim.opt.relativenumber = true
vim.opt.cursorcolumn = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.o.statuscolumn = "%s %l %r"

-- ╭──────────────────────────────────────────────────────────╮
-- │ Treesitter                                               │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "eex",
  "elixir",
  "heex",
  "prisma"
}
lvim.builtin.treesitter.highlight.enable = false

-- ╭──────────────────────────────────────────────────────────╮
-- │ LuaLine                                                  │
-- ╰──────────────────────────────────────────────────────────╯
lvim.builtin.lualine.options = {
  icons_enabled = true,
  theme = 'auto',
  component_separators = { left = '', right = '' },
  section_separators = { left = '', right = '' },
  disabled_filetypes = {},
  always_divide_middle = true,
  globalstatus = false,
}

lvim.builtin.lualine.sections = {
  lualine_a = { 'g:coc_status', { 'bo:filetype', icon = { '󰵮' } } },
  lualine_b = { { 'branch', icons_enabled = true, icon = { '' } }, {
    'diff',
    symbols = { added = ' ', modified = ' ', removed = ' ' },
    diff_color = {
      added = { fg = "#99c794" },
      modified = { fg = "#5bb7b8" },
      removed = { fg = "#ec5f67" },
    }
  }, 'diagnostics' },
  lualine_c = { { 'filename', icon = { '' } }, 'filesize' },
  lualine_x = { 'encoding', 'fileformat', 'filetype' },
  lualine_y = { 'progress' },
  lualine_z = { { 'location', icon = { '', align = 'right' } } }
}

lvim.builtin.lualine.inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { { 'filename', icon = { '' } } },
  lualine_x = { { 'location', icon = { '', align = 'right' } } },
  lualine_y = {},
  lualine_z = {}
}

lvim.builtin.lualine.extensions = { 'fzf' }

-- ╭──────────────────────────────────────────────────────────╮
-- │ Diagnostics                                              │
-- ╰──────────────────────────────────────────────────────────╯
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    border = "single",
    format = function(diagnostic)
      local source = diagnostic.source or "Unknown source"
      local code = diagnostic.code or
          (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code) or "No code"
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        source,
        code
      )
    end,
  },
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ Plugins                                                  │
-- ╰──────────────────────────────────────────────────────────╯
lvim.plugins = {
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
  { 'andweeb/presence.nvim' },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
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

-- ╭──────────────────────────────────────────────────────────╮
-- │ Telescope Extensions                                     │
-- ╰──────────────────────────────────────────────────────────╯
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        borderchars = {
          { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        width = 0.8,
      })
    },
    ["noice"] = {
      require("telescope.themes").get_dropdown({
        borderchars = {
          { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
          results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        width = 0.8,
      })
    },
  }
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("noice")

-- ╭──────────────────────────────────────────────────────────╮
-- │ Dap & Adapters                                           │
-- ╰──────────────────────────────────────────────────────────╯
vim.g.dap_virtual_text = true
local dap = require("dap")


dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  }
}

dap.adapters["pwa-chrome"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  }
}
