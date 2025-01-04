local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")

-- efm setups
local vale = require("config.plugins.configs.lspconfig.efm.vale")
local eslint = require("config.plugins.configs.lspconfig.efm.eslint")
-- local rslint = require("config.plugins.configs.lspconfig.efm.rslint")
local jq = require("config.plugins.configs.lspconfig.efm.jq")
local json_prettier =
  require("config.plugins.configs.lspconfig.efm.json-prettier")
local prettier = require("config.plugins.configs.lspconfig.efm.prettier")
local stylua = require("config.plugins.configs.lspconfig.efm.stylua")
local luacheck = require("config.plugins.configs.lspconfig.efm.luacheck")
local rustfmt = require("config.plugins.configs.lspconfig.efm.rustfmt")
local python = require("config.plugins.configs.lspconfig.efm.python")
local dprint = require("config.plugins.configs.lspconfig.efm.dprint")
local shellcheck = require("config.plugins.configs.lspconfig.efm.shellcheck")
local shfmt = require("config.plugins.configs.lspconfig.efm.shfmt")
local gofmt = require("config.plugins.configs.lspconfig.efm.gofmt")
local goimports = require("config.plugins.configs.lspconfig.efm.goimports")
local golines = require("config.plugins.configs.lspconfig.efm.golines")
local sql = require("config.plugins.configs.lspconfig.efm.sql")
local scalafmt = require("config.plugins.configs.lspconfig.efm.scalafmt")

-- formatting and linting with efm
lspconfig.efm.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      local au_lsp = vim.api.nvim_create_augroup("efm_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          if vim.g.autoformat then
            vim.lsp.buf.format({ async = false, timeout_ms = 7000 })
          end
        end,
        group = au_lsp,
      })
    end
    lsp.on_attach(client, bufnr)
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
    ".vale.ini",
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
      ".vale.ini",
    },
    languages = {
      typescript = { prettier, eslint },
      typescriptreact = { prettier, eslint },
      javascript = { prettier },
      javascriptreact = { prettier },
      lua = { stylua, luacheck },
      rust = { rustfmt },
      go = { gofmt, goimports, golines },
      markdown = { dprint, vale },
      txt = { vale },
      org = { vale },
      sql = { sql },
      json = { json_prettier, jq },
      toml = { dprint },
      python = { python },
      bash = { shellcheck, shfmt },
      sh = { shellcheck, shfmt },
      scala = { scalafmt },
    },
  },
  filetypes = {
    "lua",
    "python",
    "bash",
    "sh",
    "json",
    "toml",
    "sql",
    "scala",
    "go",
    "txt",
    "org",
    "markdown",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "typescript",
  },
})
