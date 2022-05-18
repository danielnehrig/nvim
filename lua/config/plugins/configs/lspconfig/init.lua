local global = require("config.core.global")
local map = vim.keymap.set
local fn = vim.fn

local LSP = {}
LSP.__index = LSP

-- custom attach config for most LSP configs
function LSP.on_attach(client, bufnr)
  local present, lsp_status = pcall(require, "lsp-status")
  if present then
    lsp_status.on_attach(client)
  end

  map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
  map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  map(
    "n",
    "<C-w>gd",
    "<cmd>split | lua vim.lsp.buf.definition()<CR>",
    { buffer = bufnr }
  )
  map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
  map("n", "gs", vim.lsp.buf.signature_help, { buffer = bufnr })
  map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
  map(
    "n",
    "<C-w>gi",
    "<cmd>split | lua vim.lsp.buf.implementation()<CR>",
    { buffer = bufnr }
  )
  map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  map("n", "<space>gw", vim.lsp.buf.document_symbol, { buffer = bufnr })
  map("n", "<space>gW", vim.lsp.buf.workspace_symbol, { buffer = bufnr })
  map("n", "<Leader>gf", vim.lsp.buf.code_action, { buffer = bufnr })
  map("v", "<Leader>gf", vim.lsp.buf.range_code_action, { buffer = bufnr })
  map(
    "n",
    "<space>gr",
    "<cmd>lua require('config.plugins.configs.lspconfig.utils').rename()<CR>",
    { buffer = bufnr }
  )
  map("n", "<space>g=", function()
    vim.lsp.buf.formatting_sync({}, 2500)
  end, { buffer = bufnr })
  map("n", "<space>gi", vim.lsp.buf.incoming_calls, { buffer = bufnr })
  map("n", "<space>go", vim.lsp.buf.outgoing_calls, { buffer = bufnr })
  map(
    "n",
    "<space>gd",
    "<cmd>lua vim.diagnostic.open_float({focusable = false, border = 'single', source = 'if_many' })<CR>",
    { buffer = bufnr }
  )

  if client.resolved_capabilities.document_highlight then
    local ft = "*." .. client.config.filetypes[1]
    local au_lsp = vim.api.nvim_create_augroup(
      "lsp_" .. client.name,
      { clear = true }
    )
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
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = global.border_style,
    }
  )
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
