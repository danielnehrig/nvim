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

  require("config.core.mappings").set_lsp_mapping(bufnr)

  if client.server_capabilities.document_highlight then
    local ft = "*." .. client.config.filetypes[1]
    local au_lsp =
      vim.api.nvim_create_augroup("lsp_" .. client.name, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      pattern = ft,
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight lsp references",
      group = au_lsp,
    })
    vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
      pattern = ft,
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight lsp references",
      group = au_lsp,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      pattern = ft,
      callback = vim.lsp.buf.clear_references,
      desc = "Highlight lsp references",
      group = au_lsp,
    })
  end

  fn.sign_define(
    "DiagnosticSignError",
    { texthl = "DiagnosticError", text = " " }
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
    { texthl = "DiagnosticHint", text = " " }
  )
end

-- LSP Settings
function LSP.settings()
  vim.diagnostic.config({
    virtual_text = false,
  })

  -- enable border for hover
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
    "groovy",
    "python",
    "css",
    "cs",
    "go",
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
