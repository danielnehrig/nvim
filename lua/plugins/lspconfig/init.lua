local map = require "utils".map
local autocmd = require "utils".autocmd
local fn = vim.fn
local LSP = {}
LSP.__index = LSP

-- custom attach config for most LSP configs
function LSP:on_attach(client, bufnr)
    if not packer_plugins["lsp_signature.nvim"].loaded then
        vim.cmd [[packadd lsp_signature.nvim]]
    end

    if packer_plugins["lsp-status.nvim"].loaded then
        local lsp_status = require("plugins.lspStatus").lsp_status
        lsp_status.on_attach(client)
    end

    map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    map(bufnr, "n", "<C-w>gd", "<cmd>split | lua vim.lsp.buf.definition()<CR>")
    map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    map(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    map(bufnr, "n", "<C-w>gi", "<cmd>split | lua vim.lsp.buf.implementation()<CR>")
    map(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    map(bufnr, "n", "<space>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    map(bufnr, "n", "<space>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    map(bufnr, "n", "<space>gh", "<cmd>lua vim.lsp.buf.hover()<CR>")
    map(bufnr, "n", "<space>gf", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    map(bufnr, "n", "<space>ge", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>")
    map(bufnr, "n", "<space>gr", "<cmd>lua vim.lsp.buf.rename()<CR>")
    map(bufnr, "n", "<space>g=", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    map(bufnr, "n", "<space>gi", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
    map(bufnr, "n", "<space>go", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>")
    map(bufnr, "n", "<space>gd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = 'single' })<CR>")

    autocmd("CursorHold", "<buffer>", "lua vim.lsp.diagnostic.show_line_diagnostics({border = 'single' })")

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

-- enable border
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single"
    }
)

-- enable border
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = "single"
    }
)

-- disable virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false
    }
)

-- load all language files
function LSP:init()
    local servers = {
        "lua",
        "rust",
        "python",
        "css",
        "go",
        "docker",
        "yaml",
        "bash",
        "ts",
        "java",
        "php",
        "efm",
        "c"
    }
    for _, server in ipairs(servers) do
        local settings = {lsp_config = "plugins.lspconfig." .. server}
        require(settings.lsp_config)
    end
end

return LSP
