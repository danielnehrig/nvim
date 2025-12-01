local lsp = require("config.plugins.configs.lspconfig")

vim.lsp.config("html", {
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
