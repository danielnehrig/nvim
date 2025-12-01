local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities

vim.lsp.config("nil_ls", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
