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

local function diff_label()
  local name = vim.api.nvim_buf_get_name(0)
  if name:match("^gitsigns://") then
    local revision = name:match("^gitsigns://.*//(:?[^:]+):")
    local labels = {
      [":0"] = "INDEX (staged version)",
      [":1"] = "BASE (common ancestor)",
      [":2"] = "OURS",
      [":3"] = "THEIRS",
    }
    return labels[revision] or ("GIT " .. (revision or "revision"))
  end
  if vim.wo.diff and vim.bo.buftype == "" then
    return "WORKING COPY (your edits)"
  end
  return ""
end

require("lualine").setup({
	winbar = { lualine_c = { diff_label, "filename" } },
	inactive_winbar = { lualine_c = { diff_label, "filename" } },
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
	renderer = {
		decorators = {
			require("config.tree-type-icons"),
			"Git", "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut",
		},
		icons = {
			git_placement = "after",
			show = { file = false, folder = false },
			glyphs = {
				git = {
					unstaged = "🄼",
					staged = "🅂",
					unmerged = "!",
					renamed = "🅁",
					untracked = "🅄",
					deleted = "🄳",
					ignored = "🄸",
				},
			},
		},
	},
})
-- Keep Git badge colors when the colorscheme is reloaded.
local function set_tree_git_colors()
	local colors = {
		NvimTreeGitDirtyIcon = "#81b88b",
		NvimTreeGitStagedIcon = "#81b88b",
		NvimTreeGitMergeIcon = "#e4676b",
		NvimTreeGitRenamedIcon = "#73c991",
		NvimTreeGitNewIcon = "#e5c07b",
		NvimTreeGitDeletedIcon = "#c74e39",
		NvimTreeGitIgnoredIcon = "#8c8c8c",
	}
	for group, color in pairs(colors) do
		vim.api.nvim_set_hl(0, group, { fg = color })
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("NvimTreeGitColors", { clear = true }),
	callback = set_tree_git_colors,
})
set_tree_git_colors()
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
