-- Entry point for LunarVim configuration
-- Modular configuration files

-- Load all configuration modules
require("user.core")        -- Basic settings
require("user.ui")          -- UI elements (colorscheme, lualine, etc)
require("user.keymaps")     -- Key mappings
require("user.plugins")     -- Plugin definitions
require("user.telescope")   -- Telescope configuration
require("user.functions")   -- Custom functions
require("user.diagnostics") -- Diagnostic settings
require("user.debugging")   -- DAP configuration
