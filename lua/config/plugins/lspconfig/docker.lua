local lspconfig = require("lspconfig")
local lsp = require("config.plugins.lspconfig")

lspconfig.dockerls.setup({
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
