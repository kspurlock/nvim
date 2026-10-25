local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

vim.api.nvim_create_user_command("Refresh", function()
  -- Reload core configuration while retaining package and deferred-loader state.
  -- Plugin setup changes still require a restart.
  local ok, err = pcall(function()
    for _, name in ipairs({
      "config.options",
      "config.keymaps",
      "config.autocmds",
      "config.commands",
    }) do
      package.loaded[name] = nil
    end
    dofile(config_dir .. "/init.lua")
    vim.cmd("redraw!")
  end)

  if ok then
    vim.notify("Core configuration refreshed")
  else
    vim.notify("Refresh failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Reload core configuration without closing Neovim" })
