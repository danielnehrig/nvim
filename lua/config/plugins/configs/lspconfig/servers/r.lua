local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
local lspconfig = require("lspconfig")

lspconfig.r_language_server.setup({
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      local au_lsp = vim.api.nvim_create_augroup("r_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.r",
        callback = function()
          if vim.g.autoformat then
            vim.lsp.buf.format({ async = false, timeout_ms = 7000 })
          end
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
})
