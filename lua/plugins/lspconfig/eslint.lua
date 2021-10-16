local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local capabilities = require("plugins.lspconfig.capabilities").capabilities

lspconfig.eslint.setup({
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
