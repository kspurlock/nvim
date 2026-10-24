-- Core keymaps (plugin-specific bindings live in their setup modules).
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })

vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float({ scope = "cursor", focusable = true })
end, { desc = "Show diagnostic at cursor" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Buffer diagnostics" })
