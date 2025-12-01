local lsp = require("config.plugins.configs.lspconfig")

vim.lsp.config("csharp_ls", {
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
