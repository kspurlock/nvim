-- Install package manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require("lazy").setup({
"tpope/vim-fugitive", --Git commands in nvim
"tpope/vim-rhubarb", --Fugitive-companion to interact with github
"cpea2506/one_monokai.nvim",
"nvim-lualine/lualine.nvim", --Statusline
"lukas-reineke/indent-blankline.nvim", --Add indentation guides even on blank lines
"williamboman/mason.nvim", --Automatically install LSPs to stdpath for neovim
"williamboman/mason-lspconfig.nvim",
"neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
"folke/neodev.nvim", -- Lua language server configuration for nvim
{"L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" }},
{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },}, -- Autocompletion
{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
{"nvim-telescope/telescope-fzf-native.nvim"},
{"nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }},
--"Vigemus/iron.nvim",
"nvim-treesitter/nvim-treesitter",
{'dccsillag/magma-nvim', build = { ':UpdateRemotePlugins' }, dev = true},
--{'dstein64/vim-startuptime', }
}, {})

------------------------------------------------------------
--Setups
------------------------------------------------------------

require("luasnip.loaders.from_vscode").lazy_load()

--Set statusbar
require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "one_monokai",
    component_separators = "|",
    section_separators = "",
  },}

------------------------------------------------------------
--Basic Settings
------------------------------------------------------------

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Auto command to remove line numbers on terminal
vim.api.nvim_create_autocmd({"TermOpen"}, {
pattern = {"*"},
command = "setlocal nonumber | setlocal norelativenumber"
})

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme "one_monokai"

--vim.o.completeopt = 'menuone,noselect'

--Clipboard
vim.api.nvim_set_option("clipboard","unnamed")

------------------------------------------------------------
---Keybinds
------------------------------------------------------------

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Exit termnal with Esc
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

--Magma
vim.keymap.set("n", "<LocalLeader>rr", ":MagmaEvaluateLine<CR>", {silent = true})
vim.keymap.set("x", "<LocalLeader>r", ":<C-u>MagmaEvaluateVisual<CR>")
vim.keymap.set("n", "<LocalLeader>rc", ":<C-u>MagmaEvaluateCell<CR>")


------------------------------------------------------------
---Other settings
------------------------------------------------------------
require("telescope_settings")
require("cmp_settings")
require("lsp_settings")
--require("iron_settings")

-- vim: ts=2 sts=2 sw=2 et
