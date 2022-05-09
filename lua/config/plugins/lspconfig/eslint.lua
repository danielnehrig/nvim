local lspconfig = require("lspconfig")
local lsp = require("config.plugins.lspconfig")
local capabilities =
  require("config.plugins.lspconfig.capabilities").capabilities

lspconfig.eslint.setup({
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      local au_lsp = vim.api.nvim_create_augroup("efm_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.formatting_sync()
        end,
        group = au_lsp,
      })
    end
    lsp.on_attach(client, bufnr)
  end,
})
