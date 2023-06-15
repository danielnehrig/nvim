local lsp = require("config.plugins.configs.lspconfig")
local lspconfig = require("lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
local M = {}

-- Lua Settings for nvim config and plugin development

local present, neodev = pcall(require, "neodev")
if not present then
  vim.cmd([[packadd neodev.nvim]])
end

neodev.setup({})

lspconfig.lua_ls.setup({
  cmd = { "lua-language-server" },
  flags = { debounce_text_changes = 500 },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    local n_present, navic = pcall(require, "nvim-navic")
    if n_present then
      if client.supports_method("textDocument/documentSymbol") then
        navic.attach(client, bufnr)
      end
    end
    lsp.on_attach(client, bufnr)
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

return M
