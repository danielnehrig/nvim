local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")

lspconfig.html.setup({
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
