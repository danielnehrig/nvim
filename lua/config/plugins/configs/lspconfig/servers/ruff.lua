local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities

local config = {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      local au_lsp = vim.api.nvim_create_augroup("ruff_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
        group = au_lsp,
      })
    end
    local n_present, navic = pcall(require, "nvim-navic")
    if n_present then
      if client.supports_method("textDocument/documentSymbol") then
        navic.attach(client, bufnr)
      end
    end
    lsp.on_attach(client, bufnr)
  end,
}

lspconfig.ruff_lsp.setup(config)
