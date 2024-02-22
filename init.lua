-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require('lazy').setup({
'tpope/vim-fugitive', -- Git commands in nvim
'tpope/vim-rhubarb', -- Fugitive-companion to interact with github
'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines:
"cpea2506/one_monokai.nvim",
'nvim-lualine/lualine.nvim', --Statusline
-- Add indentation guides even on blank lines
'lukas-reineke/indent-blankline.nvim',
'williamboman/mason.nvim', -- Automatically install LSPs to stdpath for neovim
'williamboman/mason-lspconfig.nvim', -- ibid
'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
'folke/neodev.nvim', -- Lua language server configuration for nvim
{ -- Autocompletion
'hrsh7th/nvim-cmp',
dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
},
-- Fuzzy Finder (files, lsp, etc)
{ 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
{'nvim-telescope/telescope-fzf-native.nvim'},

{
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
},
{
  'renerocksai/telekasten.nvim',
  dependencies = {'nvim-telescope/telescope.nvim'}
},

'Vigemus/iron.nvim',
'nvim-treesitter/nvim-treesitter',
}
, {})

require('telekasten').setup({
  home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
})

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme 'one_monokai'


--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'one_monokai',
    component_separators = '|',
    section_separators = '',
  },
}

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.api.nvim_set_option("clipboard","unnamed")

--Other vim remaps
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])


-- LSP settings
require('mason').setup({PATH = "prepend"})
require('mason-lspconfig').setup({})

-- Add nvim-lspconfig plugin
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  local attach_opts = { silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'pyright', 'lua-language-server', 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {autocomplete = false, completeopt = "menu, menuone, preview", callSnippet= "Replace"},
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
     ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      --[[ Replace with your snippet engine (see above sections on this page)
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance() ]]
      elseif has_words_before() then
        cmp.complete()
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        end
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    --{name = 'luasnip' },
  },
}

local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"zsh"}
      }
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require("iron.view").right(40),
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')


require("telescope").load_extension "file_browser"
local actions = require("telescope.actions")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


vim.api.nvim_set_keymap(
  "n",
  "<leader>fe",
  ":Telescope file_browser<CR>",
  { noremap = true }
)

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<leader>fc",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
-- vim: ts=2 sts=2 sw=2 et
