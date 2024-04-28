local global = require("config.core.global")
local fn = vim.fn

local LSP = {}
LSP.__index = LSP

-- custom attach config for most LSP configs
function LSP.on_attach(client, bufnr)
  local present, lsp_status = pcall(require, "lsp-status")
  if present then
    lsp_status.on_attach(client)
  end
  -- client.server_capabilities.semanticTokensProvider = nil
  fn.sign_define(
    "DiagnosticSignError",
    { texthl = "DiagnosticError", text = " " }
  )
  fn.sign_define(
    "DiagnosticSignWarn",
    { texthl = "DiagnosticWarn", text = " " }
  )
  fn.sign_define(
    "DiagnosticSignInfo",
    { texthl = "DiagnosticInfo", text = " " }
  )
  fn.sign_define(
    "DiagnosticSignHint",
    { texthl = "DiagnosticHint", text = " " }
  )

  require("config.core.mappings").set_lsp_mapping(bufnr)
  if vim.version().minor > 9 then
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, {})
    end
  end
end

-- LSP Settings
function LSP.settings()
  local present, lspconfig = pcall(require, "lspconfig.ui.windows")
  if present then
    lspconfig.default_options = {
      border = global.border_style,
    }
  end

  vim.diagnostic.config({
    virtual_text = false,
    float = { border = global.border_style },
  })

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      -- Use a sharp border with `FloatBorder` highlights
      border = global.border_style,
    })

  -- enable border for signature
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = global.border_style,
    })
end

LSP.settings()

-- init lsp config
function LSP.init()
  -- the server files
  local servers = {
    "lua",
    "rust",
    "python",
    "css",
    "cs",
    "go",
    "json",
    "sql",
    "emmet",
    "docker",
    "yaml",
    "bash",
    "eslint",
    "html",
    "ts",
    "java",
    "php",
    "efm",
    "c",
  }

  -- init lspStatus
  require("config.plugins.configs.lspStatus").init()

  -- load lsp configs for languages
  for _, server in ipairs(servers) do
    local settings = {
      lsp_config = "config.plugins.configs.lspconfig.servers." .. server,
    }
    require(settings.lsp_config)
  end
end

return LSP
