-- ~/.config/nvim/init.lua
-- Main entry point for Neovim configuration

-- Set leader keys before loading any plugins or configs
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load core configuration
require("config")

-- Load plugins (will be set up later)
require("plugins")
-- In your init.lua or a separate filetype.lua file

