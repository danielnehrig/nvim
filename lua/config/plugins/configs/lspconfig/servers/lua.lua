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

neodev.setup()

lspconfig.lua_ls.setup({
  cmd = { "lua-language-server" },
  flags = { debounce_text_changes = 500 },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local l_present, lsp_status = pcall(require, "lsp-status")
    if l_present then
      lsp_status.config({
        select_symbol = function(cursor_pos, symbol)
          if symbol.valueRange then
            local value_range = {
              ["start"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[1]),
              },
              ["end"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[2]),
              },
            }

            return require("lsp-status.util").in_range(cursor_pos, value_range)
          end
        end,
      })
    end
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
      workspace = { checkThirdParty = false },
      telemetry = {
        enable = false,
      },
    },
  },
})

return M
