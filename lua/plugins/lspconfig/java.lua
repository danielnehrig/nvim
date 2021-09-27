local lsp = require("plugins.lspconfig")
local capabilities = require("plugins.lspconfig").capabilities
local lspconfig = require("lspconfig")

local home = require("core.global").home
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = home .. "/code/work/" .. workspace_dir

vim.lsp.set_log_level("trace")
lspconfig.jdtls.setup({
  filetypes = { "java" },
  cmd = { "jdtls", "-data", workspace },
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    lsp:on_attach(client, bufnr)
  end,
})
