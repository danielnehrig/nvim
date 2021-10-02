local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local global = require("core.global")

lspconfig.groovyls.setup({
  cmd = {
    "java",
    "-jar",
    global.lsp_path .. "/groovy/build/libs/" .. "groovy-all.jar",
  },
  filetypes = { "groovy" },
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
