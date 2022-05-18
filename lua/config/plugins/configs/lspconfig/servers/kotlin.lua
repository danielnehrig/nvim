local lsp = require("config.plugins.configs.lspconfig")
local capabilities = require("config.plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

lspconfig.kotlin.setup({
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
