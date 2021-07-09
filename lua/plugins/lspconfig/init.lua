local map = require "utils".map
local augroups = require "utils".nvim_create_augroups
local autocmd = require "utils".autocmd
local lsp_status = require("lsp-status")
local lspconfig = require("lspconfig")
local fn = vim.fn
local setOption = vim.api.nvim_set_option
local saga = require("lspsaga")
local globals = require("core.global")
local sumneko_root_path = os.getenv("HOME") .. "/dotfiles/lua-language-server"
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

local function prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then
        return lib
    end
    return nil
end

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
            resolve_timeout = 800,
            incomplete_delay = 400,
            max_abbr_width = 100,
            max_kind_width = 100,
            max_menu_width = 100,
            documentation = {
                border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
                winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
                max_width = 120,
                min_width = 60,
                max_height = math.floor(vim.o.lines * 0.3),
                min_height = 1
            },
            source = {
                tabnine = true,
                zsh = true,
                nvim_lsp = true,
                nvim_lua = false,
                snippets_nvim = false,
                luasnip = true,
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

    local luasnip = prequire("luasnip")

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            return true
        else
            return false
        end
    end

    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
        elseif luasnip and luasnip.expand_or_jumpable() then
            return t "<Plug>luasnip-expand-or-jump"
        elseif check_back_space() then
            return t "<Tab>"
        else
            return vim.fn["compe#complete"]()
        end
    end
    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
        elseif luasnip and luasnip.jumpable(-1) then
            return t "<Plug>luasnip-jump-prev"
        else
            return t "<S-Tab>"
        end
    end
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
    map(bufnr, "i", "<Tab>", [[v:lua._G.tab_complete()]], {expr = true})
    map(bufnr, "s", "<Tab>", [[v:lua._G.tab_complete()]], {expr = true})
    map(bufnr, "i", "<S-Tab>", [[v:lua._G.s_tab_complete()]], {noremap = true, expr = true})
    map(bufnr, "s", "<S-Tab>", [[v:lua._G.s_tab_complete()]], {noremap = true, expr = true})

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
                    -- disable TS formatting since we use efm
                    client.resolved_capabilities.document_formatting = false

                    custom_attach(client, bufnr)
                end
            }
        }
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
