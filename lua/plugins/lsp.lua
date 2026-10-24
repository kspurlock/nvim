require("mason").setup({ PATH = "prepend" })

-- Apply nvim-cmp capabilities to all LSP servers
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Python: BasedPyright
-- Automatically detects uv's project-local .venv
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
      },
    },
  },
})

-- Python: Ruff
-- Ruff handles linting, formatting and imports.
-- BasedPyright handles hover, completion and type checking.
vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

-- C#: OmniSharp
-- Mason provides the executable.
vim.lsp.config("omnisharp", {})

-- Lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- Buffer-local LSP keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", {
    clear = true,
  }),
  callback = function(event)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = event.buf,
        silent = true,
        desc = desc,
      })
    end

    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

    map("n", "gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, "Go to definition in split")

    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

    map("n", "<leader>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, "List workspace folders")

    map("n", "<leader>D", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  end,
})



require("mason-lspconfig").setup({
  ensure_installed = { "basedpyright", "ruff", "omnisharp", "lua_ls", "ts_ls" },
  automatic_enable = { "basedpyright", "ruff", "omnisharp", "lua_ls", "ts_ls" },
})
