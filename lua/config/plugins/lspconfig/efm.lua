local lspconfig = require("lspconfig")
local augroups = require("config.utils").nvim_create_augroups

-- efm setups
local eslint = require("config.plugins.efm.eslint")
local prettier = require("config.plugins.efm.prettier")
-- local luafmt = require("config.plugins.efm.luafmt")
local stylua = require("config.plugins.efm.stylua")
local luacheck = require("config.plugins.efm.luacheck")
local rustfmt = require("config.plugins.efm.rustfmt")
local python = require("config.plugins.efm.python")
local dprint = require("config.plugins.efm.dprint")
local shellcheck = require("config.plugins.efm.shellcheck")
local shfmt = require("config.plugins.efm.shfmt")

-- formatting and linting with efm
lspconfig.efm.setup({
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    if client.resolved_capabilities.document_formatting then
      local autocmds = {
        Format = {
          {
            "BufWritePre",
            "<buffer>",
            "lua vim.lsp.buf.formatting_sync()",
          },
        },
      }
      augroups(autocmds)
    end
  end,
  root_dir = require("lspconfig/util").root_pattern(
    "package.json",
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
    rootMarkers = { "package.json", "go.mod", ".git/", ".zshrc" },
    languages = {
      typescript = { prettier, eslint },
      typescriptreact = { prettier, eslint },
      javascript = { prettier, eslint },
      javascriptreact = { prettier, eslint },
      lua = { stylua, luacheck },
      rust = { rustfmt },
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
    "markdown",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "typescript",
  },
})
