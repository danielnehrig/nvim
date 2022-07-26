local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    -- disable TS formatting since we use efm
    client.server_capabilities.documentFormattingProvider = false
    local n_present, navic = pcall(require, "nvim-navic")
    if n_present then
      if client.supports_method("textDocument/documentSymbol") then
        navic.attach(client, bufnr)
      end
    end

    lsp.on_attach(client, bufnr)
  end,
})
