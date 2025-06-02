-- ╭──────────────────────────────────────────────────────────╮
-- │ Core Settings                                            │
-- ╰──────────────────────────────────────────────────────────╯

-- Leader Key
lvim.leader = "space"

-- Buffer Motions
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- Terminals
lvim.builtin.terminal.execs = {
  { vim.o.shell, "<C-1>", "Horizontal Terminal", "horizontal", 0.5 },
  { vim.o.shell, "<C-2>", "Vertical Terminal",   "vertical",   0.5 },
  { vim.o.shell, "<C-3>", "Float Terminal",      "float",      nil }
}

-- Default LunarVim Configs
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "catppuccin-mocha"
lvim.transparent_window = true

-- NvimTree Settings
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.setup.filters.dotfiles = false

-- Default Vim Configs
vim.opt.relativenumber = true
vim.opt.cursorcolumn = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.o.statuscolumn = "%s %l %r"

-- Treesitter
lvim.builtin.treesitter.ensure_installed = {
  "bash", "c", "javascript", "json", "lua", "python",
  "typescript", "tsx", "css", "rust", "java", "yaml",
  "eex", "elixir", "heex", "prisma"
}
lvim.builtin.treesitter.highlight.enable = false
