-- Install package manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require("lazy").setup({
"tpope/vim-fugitive", -- Git commands in nvim
"tpope/vim-rhubarb", -- Fugitive-companion to interact with github
"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines:
"cpea2506/one_monokai.nvim",
"nvim-lualine/lualine.nvim", --Statusline
-- Add indentation guides even on blank lines
"lukas-reineke/indent-blankline.nvim",
"williamboman/mason.nvim", -- Automatically install LSPs to stdpath for neovim
"williamboman/mason-lspconfig.nvim", -- ibid
"neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
"folke/neodev.nvim", -- Lua language server configuration for nvim
{ -- Autocompletion
"hrsh7th/nvim-cmp",
dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
},
-- Fuzzy Finder (files, lsp, etc)
{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
{"nvim-telescope/telescope-fzf-native.nvim"},

{
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
},
{
  "renerocksai/telekasten.nvim",
  dependencies = {"nvim-telescope/telescope.nvim"}
},

"Vigemus/iron.nvim",
"nvim-treesitter/nvim-treesitter",

{'dccsillag/magma-nvim', build = { ':UpdateRemotePlugins' }, dev = true},
}
, {})

require("telekasten").setup({
  home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
})

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
--vim.wo.number = true
vim.wo.relativenumber = true

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

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme "one_monokai"


--Set statusbar
require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "one_monokai",
    component_separators = "|",
    section_separators = "",
  },
}

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_option("clipboard","unnamed")

--Other vim remaps
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])


--Set split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true


vim.keymap.set("n", "<LocalLeader>rip", ":MagmaEvaluateLine<CR>", {silent = true})
require("telescope_settings")
require("cmp_settings")
require("lsp_settings")
require("iron_settings")

-- vim: ts=2 sts=2 sw=2 et
