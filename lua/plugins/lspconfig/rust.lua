local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local augroups = require("utils").nvim_create_augroups
local capabilities = require("plugins.lspconfig.capabilities").capabilities

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
  ["rust-analyzer"] = {
    assist = {
      importGranularity = "module",
      importPrefix = "by_self",
    },
    cargo = {
      loadOutDirsFromCheck = true,
    },
    checkOnSave = {
      command = "clippy",
    },
    procMacro = {
      enable = true,
    },
  },
})
