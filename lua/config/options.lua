vim.o.hlsearch = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true

-- Show inline diagnostics using the theme's severity colors.
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  virtual_lines = false,
  signs = false,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
})

vim.opt.clipboard = "unnamedplus"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Show command-line completion without inserting a suggestion automatically.
vim.o.wildmode = "noselect:lastused,full"
vim.opt.wildoptions:append("pum")
