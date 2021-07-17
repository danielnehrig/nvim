local lspconfig = require("lspconfig")
local augroups = require "utils".nvim_create_augroups

-- efm setups
local eslint = require("plugins.efm.eslint")
local prettier = require("plugins.efm.prettier")
local luafmt = require("plugins.efm.luafmt")
local rustfmt = require("plugins.efm.rustfmt")
local python = require("plugins.efm.python")
local dprint = require("plugins.efm.dprint")
local shellcheck = require("plugins.efm.shellcheck")
local shfmt = require("plugins.efm.shfmt")

-- formatting and linting with efm
lspconfig.efm.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        if client.resolved_capabilities.document_formatting then
            local autocmds = {
                Format = {
                    {"BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting()"}
                }
            }
            augroups(autocmds)
        end
    end,
    root_dir = function()
        return vim.fn.getcwd()
    end,
    init_options = {
        documentFormatting = true,
        documentSymbol = false,
        completion = false,
        codeAction = false,
        hover = false
    },
    settings = {
        rootMarkers = {"package.json", "go.mod", ".git/", ".zshrc"},
        languages = {
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            lua = {luafmt},
            rust = {rustfmt},
            markdown = {dprint},
            python = {python},
            bash = {shellcheck, shfmt},
            sh = {shellcheck, shfmt}
        }
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
        "typescript"
    }
}
