require("grapple").setup({
	--event = { "BufReadPost", "BufNewFile" },
	--cmd = "Grapple",
    --[[
	keys = {
		{ "<leader>m", ":Grapple toggle<CR>", desc = "Grapple toggle tag" },
		{ "<leader>M", ":Grapple toggle_tags<CR>", desc = "Grapple open tags window" },
		{ "<leader>n", ":Grapple cycle_tags next<CR>", desc = "Grapple cycle next tag" },
		{ "<leader>p", ":Grapple cycle_tags prev<CR>", desc = "Grapple cycle previous tag" },
	},
    --]]
})

vim.keymap.set({"n"}, "<leader>m", ":Grapple toggle<CR>", {silent = true})
vim.keymap.set({"n"}, "<leader>M", ":Grapple toggle_tags<CR>", {silent = true})
vim.keymap.set({"n"}, "<leader>n", ":Grapple cycle_tags next<CR>", {silent = true})
vim.keymap.set({"n"}, "<leader>p", ":Grapple cycle_tags prev<CR>", {silent = true})
