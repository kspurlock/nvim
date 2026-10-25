-- Neovim entry point. Core settings load before plugin initialization.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.pack")
