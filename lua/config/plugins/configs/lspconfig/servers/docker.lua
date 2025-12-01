local lsp = require("config.plugins.configs.lspconfig")

vim.lsp.config("dockerls", {
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
