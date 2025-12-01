local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities

vim.lsp.config("intelephense", {
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
