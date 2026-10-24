-- Small native triggers; package installation and updates remain with vim.pack.
local loaded = {}
local function load(name, packages, setup)
  if loaded[name] then return end
  for _, package in ipairs(packages) do
    vim.cmd.packadd(package)
  end
  setup()
  loaded[name] = true
end

local function telescope()
  load("telescope", {
    "plenary.nvim", "telescope.nvim", "telescope-fzf-native.nvim",
    "telescope-file-browser.nvim",
  }, function() require("plugins.telescope") end)
end

-- Remove all placeholders before sourcing the real plugin commands.
local function commands(names, loader)
  local function activate()
    for _, name in ipairs(names) do
      pcall(vim.api.nvim_del_user_command, name)
    end
    loader()
  end
  for _, name in ipairs(names) do
    vim.api.nvim_create_user_command(name, function(args)
      activate()
      vim.api.nvim_cmd({ cmd = name, args = args.fargs, bang = args.bang,
        mods = args.smods }, {})
    end, {
      nargs = "*", bang = true,
      complete = function(_, line, _)
        activate()
        return vim.fn.getcompletion(line, "cmdline")
      end,
    })
  end
end

commands({ "Telescope" }, telescope)
for key, picker in pairs({ ff = "find_files", fg = "live_grep", fb = "buffers", fh = "help_tags" }) do
  vim.keymap.set("n", "<leader>" .. key, function()
    telescope()
    require("telescope.builtin")[picker]()
  end, { desc = "Telescope " .. picker })
end
vim.keymap.set("n", "<leader>fe", function()
  telescope()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"), select_buffer = true,
  })
end, { desc = "File browser" })

commands({ "LazyGit", "LazyGitLog", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" }, function()
  load("lazygit", { "plenary.nvim", "lazygit.nvim" }, function() end)
end)

local group = vim.api.nvim_create_augroup("UserDeferredPlugins", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group, once = true, nested = true,
  callback = function()
    load("completion", { "friendly-snippets", "LuaSnip", "nvim-cmp", "cmp-buffer", "cmp_luasnip" }, function()
      require("plugins.completion")
    end)
    -- Newly registered completion handlers must see the first InsertEnter too.
    vim.api.nvim_exec_autocmds("InsertEnter", { group = "___cmp___", modeline = false })
  end,
})

local function colors()
  load("colors", { "oklch-color-picker.nvim" }, function()
    require("oklch-color-picker").setup({})
  end)
end
commands({ "ColorPickOklch" }, colors)

-- Color highlighting is useful in file buffers, not on the empty startup screen.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = group, once = true,
  callback = function()
    vim.schedule(colors)
  end,
})
