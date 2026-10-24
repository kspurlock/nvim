require("monokai-pro").setup()
vim.cmd.colorscheme("monokai-pro")
require("ibl").setup({})
require("noice").setup({
  routes = {
    {
      filter = { event = "msg_show", kind = { "shell_out", "shell_err", "shell_ret" } },
      view = "split",
      opts = { enter = true, title = "Shell output", format = { "{message}" } },
    },
  },
})
local noice = require("noice")

require("lualine").setup({
	options = {
		icons_enabled = false,
		component_separators = "|",
		section_separators = "|",
	},

    --[[
	sections = {
		lualine_x = {
			{
				noice.api.status.message.get_hl,
				cond = noice.api.status.message.has,
			},
			{
				noice.api.status.command.get,
				cond = noice.api.status.command.has,
				color = { fg = "#ff9e64" },
			},
			{
				noice.api.status.mode.get,
				cond = noice.api.status.mode.has,
				color = { fg = "#ff9e64" },
			},
			{
				noice.api.status.search.get,
				cond = noice.api.status.search.has,
				color = { fg = "#ff9e64" },
			},
		},
    
	},
    ]]
})

require("nvim-tree").setup({
	tab = {
		sync = {
			open = true,
		},
	},
})
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
