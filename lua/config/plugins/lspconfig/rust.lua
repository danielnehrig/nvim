local lspconfig = require("lspconfig")
local lsp = require("config.plugins.lspconfig")
local augroups = require("config.utils").nvim_create_augroups
local capabilities =
  require("config.plugins.lspconfig.capabilities").capabilities

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      local autocmds = {
        Format = {
          {
            "BufWritePre",
            "<buffer>",
            "lua vim.lsp.buf.formatting()",
          },
        },
      }
      augroups(autocmds)
    end
    lsp.on_attach(client, bufnr)
  end,
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        enable = false,
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
