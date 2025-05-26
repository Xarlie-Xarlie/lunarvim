-- ╭──────────────────────────────────────────────────────────╮
-- │ UI Configuration                                         │
-- ╰──────────────────────────────────────────────────────────╯

--- ╭──────────────────────────────────────────────────────────╮
--- │ Noice Notification                                       │
--- ╰──────────────────────────────────────────────────────────╯
require("notify").setup({
  background_colour = "#ffffff",
})

--- ╭──────────────────────────────────────────────────────────╮
--- │ LuaLine                                                  │
--- ╰──────────────────────────────────────────────────────────╯
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
