local lspconfig = require("lspconfig")

-- efm setups
local eslint = require("config.plugins.efm.eslint")
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
    client.server_capabilities.document_formatting = true
    if client.resolved_capabilities.document_formatting then
      local au_lsp = vim.api.nvim_create_augroup("efm_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format()
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
    "stylua.toml"
  ),
  init_options = {
    documentFormatting = true,
    documentSymbol = false,
    completion = false,
    codeAction = false,
    hover = false,
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
      typescript = { prettier, eslint },
      typescriptreact = { prettier, eslint },
      javascript = { prettier, eslint },
      javascriptreact = { prettier, eslint },
      lua = { stylua, luacheck },
      rust = { rustfmt },
      go = { gofmt, goimports, golines },
      markdown = { dprint },
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
    "go",
    "markdown",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "typescript",
  },
})
