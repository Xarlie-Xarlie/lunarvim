-- ╭──────────────────────────────────────────────────────────╮
-- │ Telescope Configuration                                  │
-- ╰──────────────────────────────────────────────────────────╯

-- Telescope Config
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

-- Telescope Extensions
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({})
    },
    ["noice"] = {
      require("telescope.themes").get_dropdown({})
    },
  }
})

require("telescope").load_extension("ui-select")
require("telescope").load_extension("noice")
