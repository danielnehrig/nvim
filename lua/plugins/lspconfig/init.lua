local map = require "utils".map
local map_global = require "utils".map_global
local augroups = require "utils".nvim_create_augroups
local autocmd = require "utils".autocmd
local lsp_status = require("lsp-status")
local lspconfig = require("lspconfig")
local fn = vim.fn
local setOption = vim.api.nvim_set_option
local saga = require("lspsaga")
local globals = require("core.global")
local sumneko_root_path = os.getenv("HOME") .. "/.dotfiles-darwin/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. globals.os_name .. "/lua-language-server"

-- set omnifunc needed for compe
setOption("omnifunc", "v:lua.vim.lsp.omnifunc")

-- snippets setup
-- https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}

-- lsp object for exporting and lazyload
local lsp = {}
-- compe setup
function lsp:compe()
    require("compe").setup(
        {
            enabled = true,
            autocomplete = true,
            debug = false,
            min_length = 1,
            preselect = "enable",
            throttle_time = 80,
            source_timeout = 200,
            incomplete_delay = 400,
            max_abbr_width = 100,
            max_kind_width = 100,
            max_menu_width = 100,
            documentation = true,
            source = {
                nvim_lsp = true,
                nvim_lua = false,
                snippets_nvim = true,
                path = true,
                buffer = false,
                calc = true,
                vsnip = false,
                spell = false,
                tags = false,
                treesitter = false
            }
        }
    )
end

-- completion menu settings
vim.o.completeopt = "menuone,noselect"

-- formatting and save
-- Overwrite the formatting handler
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

-- saga setup
-- TODO: rethink might remove
saga.init_lsp_saga {
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 20,
        virtual_text = false
    },
    error_sign = "", -- 
    warn_sign = "",
    hint_sign = "",
    infor_sign = ""
}

lsp_status.register_progress()
-- custom attach config for most LSP configs
local custom_attach = function(client, bufnr)
    if not packer_plugins["lsp_signature.nvim"].loaded then
        vim.cmd [[packadd lsp_signature.nvim]]
    end
    lsp_status.on_attach(client)

    map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    map(bufnr, "n", "<space>gd", '<cmd>lua require("lspsaga.provider").preview_definition()<CR>')
    map(bufnr, "n", "K", '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
    map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    map(bufnr, "n", "<space>gr", "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>")
    map(bufnr, "n", "gs", '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
    map(bufnr, "i", "<C-g>", '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
    map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    map(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    map(bufnr, "n", "<space>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    map(bufnr, "n", "<space>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    map(bufnr, "n", "<space>ah", "<cmd>lua vim.lsp.buf.hover()<CR>")
    map(bufnr, "n", "<space>af", '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
    map(bufnr, "v", "<space>ac", '<cmd>lua require("lspsaga.codeaction").range_code_action()<CR>')
    map(bufnr, "n", "<space>ge", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>")
    map(bufnr, "n", "<space>ar", '<cmd>lua require("lspsaga.rename").rename()<CR>')
    map(bufnr, "n", "gh", '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
    map(bufnr, "n", "<space>=", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    map(bufnr, "n", "<space>ai", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
    map(bufnr, "n", "<space>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>")
    map(bufnr, "i", "<C-space>", "<cmd>call compe#complete()<CR>")
    map(bufnr, "i", "<C-e>", "<cmd>call compe#close('<C-e>')<CR>")
    map(bufnr, "i", "<C-f>", "<cmd>call compe#scroll({ delta: +4 })<CR>")
    map(bufnr, "i", "<C-d>", "<cmd>call compe#scroll({ delta: -4 })<CR>")
    map(bufnr, "n", "<space>cd", '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>')
    map(bufnr, "i", "<c-k>", '<cmd>lua return require"snippets".expand_or_advance(1)')
    map(bufnr, "i", "<c-j>", '<cmd>lua return require"snippets".advance_snippet(-1)<CR>')

    autocmd("CursorHold", "<buffer>", "lua require'lspsaga.diagnostic'.show_line_diagnostics()")

    fn.sign_define("LspDiagnosticsSignError", {text = ""})
    fn.sign_define("LspDiagnosticsSignWarning", {text = ""})
    fn.sign_define("LspDiagnosticsSignInformation", {text = ""})
    fn.sign_define("LspDiagnosticsSignHint", {text = ""})

    require "lsp_signature".on_attach(
        {
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            -- If you want to hook lspsaga or other signature handler, pls set to false
            doc_lines = 6, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
            -- set to 0 if you DO NOT want any API comments be shown
            -- This setting only take effect in insert mode, it does not affect signature help in normal
            -- mode
            floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
            hint_enable = true, -- virtual hint enable
            hint_prefix = "", -- Panda for parameter
            hint_scheme = "String",
            use_lspsaga = false, -- set to true if you want to use lspsaga popup
            hi_parameter = "FloatBorder", -- how your parameter will be highlight
            handler_opts = {
                border = "single" -- double, single, shadow, none
            }
            -- deprecate
            -- decorator = {"`", "`"}  -- decoractor can be `decorator = {"***", "***"}`  `decorator = {"**", "**"}` `decorator = {"**_", "_**"}`
            -- `decorator = {"*", "*"} see markdown help for more details
            -- <u></u> ~ ~ does not supported by nvim
        }
    )
end

-- Lua Settings for nvim config and plugin development
local luadev =
    require("lua-dev").setup(
    {
        lspconfig = {
            on_attach = custom_attach,
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}
        }
    }
)

-- navigator setup also sets up some LSP configs for
-- rust and tsserver and sumenko lua
local single = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
require("navigator").setup(
    {
        default_mapping = false,
        border = single,
        code_action_prompt = {enable = false, sign = true, sign_priority = 40, virtual_text = true},
        lsp = {
            format_on_save = false,
            sumneko_lua = {
                sumneko_root_path = sumneko_root_path,
                sumneko_binary = sumneko_binary,
                settings = luadev.settings,
                on_attach = function(client, bufnr)
                    custom_attach(client, bufnr)
                end
            },
            rust_analyzer = {
                on_attach = function(client, bufnr)
                    custom_attach(client, bufnr)
                end
            },
            tsserver = {
                filetypes = {"typescript", "typescriptreact"},
                on_attach = function(client, bufnr)
                    vim.cmd [[packadd nvim-lsp-ts-utils]]
                    local ts_utils = require("nvim-lsp-ts-utils")

                    -- disable TS formatting since we use efm
                    client.resolved_capabilities.document_formatting = false

                    -- ts utils code action and file import update
                    ts_utils.setup {
                        debug = false,
                        disable_commands = false,
                        enable_import_on_completion = false,
                        import_on_completion_timeout = 5000,
                        -- eslint
                        eslint_enable_code_actions = true,
                        eslint_bin = "eslint_d",
                        eslint_args = {"-f", "json", "--stdin", "--stdin-filename", "$FILENAME"},
                        eslint_enable_disable_comments = true,
                        -- experimental settings!
                        -- eslint diagnostics
                        eslint_enable_diagnostics = false,
                        eslint_diagnostics_debounce = 250,
                        -- formatting
                        enable_formatting = false,
                        formatter = "prettier_d_slim",
                        formatter_args = {"--stdin-filepath", "$FILENAME"},
                        format_on_save = true,
                        no_save_after_format = false,
                        -- parentheses completion
                        complete_parens = false,
                        signature_help_in_parens = false,
                        -- update imports on file move
                        update_imports_on_move = true,
                        require_confirmation_on_move = false,
                        watch_dir = "/domain"
                    }

                    ts_utils.setup_client(client)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gi", ":TSLspImportAll<CR>", {silent = true})
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ae", ":TSLspRenameFile<CR>", {silent = true})
                    custom_attach(client, bufnr)
                end
            }
        },
        on_attach = function(client, _)
            -- float
            if not packer_plugins["illuminate"].loaded then
                vim.cmd [[packadd illuminate]]
            end
            require "illuminate".on_attach(client)
        end
    }
)

-- lsp setups
lspconfig.cssls.setup {on_attach = custom_attach}
lspconfig.html.setup {on_attach = custom_attach}
lspconfig.gopls.setup {on_attach = custom_attach}
lspconfig.pyright.setup {on_attach = custom_attach}
lspconfig.dockerls.setup {on_attach = custom_attach}
lspconfig.clangd.setup {on_attach = custom_attach}
lspconfig.vimls.setup {on_attach = custom_attach}

-- efm setups
local eslint = require("plugins.efm.eslint")
local prettier = require("plugins.efm.prettier")
local luafmt = require("plugins.efm.luafmt")

-- formatting and linting with efm
lspconfig.efm.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        if client.resolved_capabilities.document_formatting then
            local autocmds = {
                Format = {
                    {"BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync()"}
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
        codeAction = true
    },
    settings = {
        languages = {
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            lua = {luafmt}
        }
    },
    filetypes = {
        "lua",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    }
}

-- disable virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false
    }
)

return lsp
