local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

lspconfig.pyright.setup {
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        lsp:on_attach(client, bufnr)
    end
}
