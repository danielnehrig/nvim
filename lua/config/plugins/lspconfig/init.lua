local map = vim.keymap.set
local fn = vim.fn

local LSP = {}
LSP.__index = LSP

-- custom attach config for most LSP configs
function LSP.on_attach(client, bufnr)
  if
    packer_plugins["lsp-status.nvim"]
    and packer_plugins["lsp-status.nvim"].loaded
  then
    local lsp_status = require("config.plugins.lspStatus").lsp_status
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
  map("n", "<space>gh", vim.lsp.buf.hover, { buffer = bufnr })
  map("n", "<Leader>gf", vim.lsp.buf.code_action, { buffer = bufnr })
  map("v", "<Leader>gf", vim.lsp.buf.range_code_action, { buffer = bufnr })
  map(
    "n",
    "<space>gr",
    "<cmd>lua require('config.plugins.lspconfig.utils').rename()<CR>",
    { buffer = bufnr }
  )
  map("n", "<space>g=", vim.lsp.buf.formatting, { buffer = bufnr })
  map("n", "<space>gi", vim.lsp.buf.incoming_calls, { buffer = bufnr })
  map("n", "<space>go", vim.lsp.buf.outgoing_calls, { buffer = bufnr })
  map(
    "n",
    "<space>gd",
    "<cmd>lua vim.diagnostic.open_float({focusable = false, border = 'single' })<CR>",
    { buffer = bufnr }
  )

  local au_lsp = vim.api.nvim_create_augroup("lsp", { clear = true })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      pattern = "*",
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight lsp references",
      group = au_lsp,
    })
    vim.api.nvim_create_autocmd("CursorHoldI", {
      pattern = "*",
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight lsp references",
      group = au_lsp,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      pattern = "*",
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
  vim.diagnostic.config({ virtual_text = false })
  -- enable border for hover
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      -- Use a sharp border with `FloatBorder` highlights
      border = "single",
    })

  -- enable border for signature
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = "single",
    }
  )

  -- disable virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
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
    -- "eslint",
    "ts",
    "java",
    "php",
    "efm",
    "c",
  }

  -- init lspStatus
  require("config.plugins.lspStatus").init()

  -- load lsp configs for languages
  for _, server in ipairs(servers) do
    local settings = { lsp_config = "config.plugins.lspconfig." .. server }
    require(settings.lsp_config)
  end
end

return LSP
