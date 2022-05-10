local lspconfig = require("lspconfig")

-- efm setups
local eslint = require("config.plugins.efm.eslint")
local rslint = require("config.plugins.efm.rslint")
local jq = require("config.plugins.efm.jq")
local json_prettier = require("config.plugins.efm.json-prettier")
local prettier = require("config.plugins.efm.prettier")
local stylua = require("config.plugins.efm.stylua")
local luacheck = require("config.plugins.efm.luacheck")
local rustfmt = require("config.plugins.efm.rustfmt")
local python = require("config.plugins.efm.python")
local dprint = require("config.plugins.efm.dprint")
local shellcheck = require("config.plugins.efm.shellcheck")
local shfmt = require("config.plugins.efm.shfmt")
local gofmt = require("config.plugins.efm.gofmt")
local goimports = require("config.plugins.efm.goimports")
local golines = require("config.plugins.efm.golines")

-- formatting and linting with efm
lspconfig.efm.setup({
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    if client.resolved_capabilities.documentFormattingProvider then
      local au_lsp = vim.api.nvim_create_augroup("efm_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = true })
        end,
        group = au_lsp,
      })
    end
  end,
  root_dir = require("lspconfig/util").root_pattern(
    "package.json",
    "cargo.toml",
    "go.mod",
    ".eslintrc",
    ".eslintrc.json",
    ".prettierrc",
    ".prettierrc.json",
    "stylua.toml",
    ".luacheck",
    "dpring.json"
  ),
  init_options = {
    documentFormatting = true,
    documentSymbol = true,
    completion = true,
    codeAction = true,
    hover = true,
  },
  settings = {
    rootMarkers = {
      "package.json",
      "go.mod",
      ".git/",
      ".zshrc",
      "cargo.toml",
    },
    languages = {
      typescript = { rslint, prettier, eslint },
      typescriptreact = { rslint, prettier, eslint },
      javascript = { rslint, prettier, eslint },
      javascriptreact = { rslint, prettier, eslint },
      lua = { stylua, luacheck },
      rust = { rustfmt },
      go = { gofmt, goimports, golines },
      markdown = { dprint },
      json = { json_prettier, jq },
      toml = { dprint },
      python = { python },
      bash = { shellcheck, shfmt },
      sh = { shellcheck, shfmt },
    },
  },
  filetypes = {
    "lua",
    "python",
    "bash",
    "sh",
    "json",
    "toml",
    "go",
    "markdown",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "typescript",
  },
})
