local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")

lspconfig.csharp_ls.setup({
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
