local globals = require("core.global")
local sumneko_root_path = os.getenv("HOME") .. "/dotfiles/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. globals.os_name .. "/lua-language-server"
local lsp = require("plugins.lspconfig")
local lspconfig = require("lspconfig")
local capabilities = require("plugins.lspconfig").capabilities

-- Lua Settings for nvim config and plugin development
local luadev =
    require("lua-dev").setup(
    {
        lspconfig = {
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}
        }
    }
)

lspconfig.sumneko_lua.setup {
    capabilities = capabilities,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = luadev.settings,
    root_dir = require("lspconfig/util").root_pattern("."),
    on_attach = function(client, bufnr)
        lsp:on_attach(client, bufnr)
    end
}
