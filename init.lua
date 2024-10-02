-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require("lazy").setup({
	dev = { path = "~/nvim_dev" },
	spec = {
		"tpope/vim-fugitive", --Git commands in nvim
		"tpope/vim-rhubarb", --Fugitive-companion to interact with github
		"cpea2506/one_monokai.nvim",
		"nvim-lualine/lualine.nvim", --Statusline
		"lukas-reineke/indent-blankline.nvim", --Add indentation guides even on blank lines
		"williamboman/mason.nvim", --Automatically install LSPs to stdpath for neovim
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
		"folke/neodev.nvim", -- Lua language server configuration for nvim
		"sindrets/diffview.nvim",

		{ "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
		{
			"hrsh7th/nvim-cmp",
			dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
		}, -- Autocompletion
		{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "nvim-telescope/telescope-fzf-native.nvim" },

		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},

		"nvim-treesitter/nvim-treesitter",
		--{ "dccsillag/magma-nvim", build = { ":UpdateRemotePlugins" }, dev=true},
		{
			"benlubas/molten-nvim",
			version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
			build = ":UpdateRemotePlugins",
			init = function()
				-- this is an example, not a default. Please see the readme for more configuration options
				vim.g.molten_output_win_max_height = 12
			end,
		},

		--{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {},
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
		},

		{ "airblade/vim-gitgutter" }, -- Git changes in sign column

		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		},

		{
			"yetone/avante.nvim",
			event = "VeryLazy",
			lazy = false,
			version = false, -- set this if you want to always pull the latest change
			opts = {
				provider = "ollama",
				vendors = {
					---@type AvanteProvider
					ollama = {
						["local"] = true,
						endpoint = "127.0.0.1:11434/v1",
						model = "llama3.1:8b",
						parse_curl_args = function(opts, code_opts)
							return {
								url = opts.endpoint .. "/chat/completions",
								headers = {
									["Accept"] = "application/json",
									["Content-Type"] = "application/json",
								},
								body = {
									model = opts.model,
									messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
									max_tokens = 2048,
									stream = true,
								},
							}
						end,
						parse_response_data = function(data_stream, event_state, opts)
							require("avante.providers").openai.parse_response(data_stream, event_state, opts)
						end,
					},
				},
			},
			-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
			build = "make",
			-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"stevearc/dressing.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				--- The below dependencies are optional,
				"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
				--"zbirenbaum/copilot.lua", -- for providers='copilot'
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							use_absolute_path = false, --Required for Windows users
						},
					},
				},
			},
		},
	},
}, {})

------------------------------------------------------------
--Setups
------------------------------------------------------------
require("luasnip.loaders.from_vscode").lazy_load()

require("ibl").setup()

require("render-markdown").setup({
	code = {
		style = "full",
	},
})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
	messages = {
		enabled = false,
	},
})

--Set statusbar
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "one_monokai",
		component_separators = "|",
		section_separators = "",
	},
})

--For Avante
vim.o.laststatus = 3
vim.api.nvim_create_user_command("AvanteInit", function()
	require("avante_lib").load()
end, {})

------------------------------------------------------------
--Basic Settings
------------------------------------------------------------

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

--Auto command to remove line numbers on terminal
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	command = "setlocal nonumber | setlocal norelativenumber",
})

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.o.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Split behavior
vim.o.splitbelow = true
vim.o.splitright = true

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme("one_monokai")

--vim.o.completeopt = 'menuone,noselect'

--Clipboard
vim.api.nvim_set_option_value("clipboard", "unnamed", {})

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

------------------------------------------------------------
---Keybinds
------------------------------------------------------------

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Exit termnal with Esc
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

--Run file
vim.keymap.set("n", "<leader>5", function()
	local filetype = vim.bo.filetype
	print(type(filetype))

	if filetype == "python" then
		vim.cmd("!python3 %")
	else
		error("Can't run this file.")
	end
end)

vim.api.nvim_create_user_command("EditInit", "e ~/.config/nvim/init.lua", {})

vim.api.nvim_create_user_command("LoadAvante", "lua require('avante_lib').load()", {})

--[[Magma
vim.keymap.set("n", "<LocalLeader>rr", ":MagmaEvaluateLine<CR>", { silent = true })
vim.keymap.set("x", "<LocalLeader>r", ":<C-u>MagmaEvaluateVisual<CR>")
vim.keymap.set("n", "<LocalLeader>rc", ":<C-u>MagmaEvaluateCell<CR>")
--]]

vim.keymap.set("n", "<LocalLeader>rr", ":MoltenEvaluateLine<CR>", { silent = true })
vim.keymap.set("x", "<LocalLeader>rr", ":<C-u>MoltenEvaluateVisual<CR>")
vim.keymap.set("n", "<LocalLeader>rc", ":<C-u>MoltenReevaluateCell<CR>")

------------------------------------------------------------
---Other settings
------------------------------------------------------------
require("telescope_settings")
require("cmp_settings")
require("lsp_settings")
--require("iron_settings")
