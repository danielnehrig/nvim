local lsp = require("plugins.lspconfig")
local capabilities = require("plugins.lspconfig").capabilities
local lspconfig = require("lspconfig")

lspconfig.jdtls.setup {
    filetypes = {"java"},
    cmd = {"jdtls"},
    capabilities = capabilities,
    flags = {debounce_text_changes = 500},
    on_attach = function(client, bufnr)
        lsp:on_attach(client, bufnr)
    end
}
