# LunarVim Configuration

A personal LunarVim setup with custom plugins, themes, utilities, and functions.

## Overview

This LunarVim configuration enhances the base LunarVim experience with:

- Multiple color schemes and themes
- Copilot integration with custom chat functionality
- Improved Telescope configurations
- Custom testing functionality
- Enhanced UI elements

## Features

### Themes

This configuration includes multiple themes that can be selected through LunarVim's theme switching:

- Dracula
- Spaceduck
- VSCode
- Sonokai
- Nightfly
- Material
- Tokyo Night
- Monokai
- PaperColor
- OneDarkPro
- Solarized
- Catppuccin

### Telescope Enhancements

- UI-select integration for better selection menus
- Custom layout configuration with 95% width/height
- Dropdown theme for UI interactions
- Noice integration

### Custom Functions

- **QuickChat**: Fast interaction with GitHub Copilot
- **CustomLiveGrep**: Enhanced file search with include/exclude patterns
- **Test in Floating Window**: Run tests in a dedicated floating window
  - Supports both JavaScript and Elixir test files

### Plugins

#### Utilities
- Marks management (`marks.nvim`)
- Discord presence (`presence.nvim`)
- Smooth scrolling (`neoscroll.nvim`)

#### Development
- GitHub Copilot integration
- CopilotChat with custom prompts
- Null-LS for linting and formatting
- Prettier integration
- Write-good diagnostics

#### UI Enhancements
- Noice.nvim for better UI notifications and command line
- Enhanced popup menu positioning
- Markdown rendering

## Setup

1. Install LunarVim following the [official documentation](https://www.lunarvim.org/docs/installation)
2. Clone this configuration to your LunarVim user config directory:
   ```
   git clone https://github.com/Xarlie-Xarlie/lunarvim.git ~/.config/lvim
   ```
3. Start LunarVim:
   ```
   lvim
   ```

## Keybindings

### Custom Functions
- Quick Chat with Copilot: Callable via Lua function `CustomQuickChat()`
- Custom Live Grep: Callable via Lua function `CustomLiveGrep()`
- Toggle Jest Floating Window: Callable via Lua function `ToggleJestFloatingWindow()`
- Run Jest in Floating Window: Callable via Lua function `RunJestInFloatingWindow(current_file)`

### Copilot
- Various prompts including specialized "Rename" functionality

## Notes

This configuration is built on top of LunarVim's core functionality. See the [LunarVim documentation](https://www.lunarvim.org/docs/configuration) for information about base configurations and capabilities.
