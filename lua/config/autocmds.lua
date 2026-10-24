-- Offer command and argument completions as the ':' command line changes.
vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("CommandLineCompletion", { clear = true }),
  pattern = ":",
  callback = function()
    -- Shell executable completion can be slow; leave it to manual Tab.
    if vim.fn.getcmdline():match("^%s*!") then
      return
    end
    vim.fn.wildtrigger()
  end,
})

-- Don't display line numbers in terminal buffers.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Preserve the original WSL-to-Windows clipboard synchronization.
if vim.fn.has("wsl") == 1 then
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("Yank", { clear = true }),
    callback = function()
      vim.fn.system("clip.exe", vim.fn.getreg('"'))
    end,
  })
end
