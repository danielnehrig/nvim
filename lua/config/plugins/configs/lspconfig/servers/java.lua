local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
local lspconfig = require("lspconfig")
local build_path_string = require("config.utils").build_path_string

local home = require("config.core.global").home
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = build_path_string(home .. "/code/workspace/" .. workspace_dir)

-- jdtls is a sh script in path which bootsup jdtls
-- yay -S jdtls (for pacman based systems)
lspconfig.jdtls.setup({
  filetypes = { "java" },
  autostart = false,
  cmd = { "jdtls", "-data", workspace },
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
