-- Native package management requires Neovim 0.12+.
assert(vim.pack and vim.pack.add, "This configuration requires Neovim 0.12+ (vim.pack)")

-- Register before add() so installs restored from the lockfile also build FZF.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserPackBuild", { clear = true }),
  callback = function(event)
    local data = event.data
    if data.spec.name ~= "telescope-fzf-native.nvim" or data.kind == "delete" then
      return
    end
    local result = vim.system({ "make" }, { cwd = data.path, text = true }):wait()
    if result.code ~= 0 then
      error("Failed to build telescope-fzf-native.nvim: " .. (result.stderr or result.stdout))
    end
  end,
})

local deferred = {
  ["LuaSnip"] = true,
  ["friendly-snippets"] = true,
  ["nvim-cmp"] = true,
  ["cmp-buffer"] = true,
  ["cmp_luasnip"] = true,
  ["telescope.nvim"] = true,
  ["telescope-fzf-native.nvim"] = true,
  ["telescope-file-browser.nvim"] = true,
  ["plenary.nvim"] = true,
  ["lazygit.nvim"] = true,
  ["oklch-color-picker.nvim"] = true,
}

vim.pack.add({
  { src = "https://github.com/L3MON4D3/LuaSnip", version = "master" },
  { src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
  { src = "https://github.com/hrsh7th/nvim-cmp", version = "main" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp", version = "main" },
  { src = "https://github.com/hrsh7th/cmp-buffer", version = "main" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip", version = "master" },
  { src = "https://github.com/eero-lehtinen/oklch-color-picker.nvim", version = vim.version.range("*") },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/stevearc/conform.nvim", version = "master" },
  { src = "https://github.com/windwp/nvim-autopairs", version = "master" },
  { src = "https://github.com/lewis6991/gitsigns.nvim", version = "main" },
  { src = "https://github.com/kdheepak/lazygit.nvim", version = "main" },
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
  { src = "https://github.com/mason-org/mason.nvim", version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig", version = "master" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim", version = "main" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("*") },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", version = "main" },
  { src = "https://github.com/nvim-telescope/telescope-file-browser.nvim", version = "master" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim", version = "master" },
  { src = "https://github.com/loctvl842/monokai-pro.nvim", version = "master" },
  { src = "https://github.com/folke/noice.nvim", version = "main" },
  { src = "https://github.com/MunifTanjim/nui.nvim", version = "main" },
  { src = "https://github.com/rcarriga/nvim-notify", version = "master" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", version = "master" },
  { src = "https://codeberg.org/andyg/leap.nvim", version = "main"}
}, {
  confirm = false,
  -- load=false only postpones plugin scripts until later in startup. A custom
  -- loader keeps deferred packages off runtimepath until their actual trigger.
  load = function(plugin)
    if not deferred[plugin.spec.name] then
      vim.cmd.packadd({ plugin.spec.name, bang = true })
    end
  end,
})

-- All packages are on runtimepath before configuration and dependency setup.
require("plugins.visual")
require("plugins.editing")
require("plugins.git")
require("plugins.lsp")
require("config.deferred")
