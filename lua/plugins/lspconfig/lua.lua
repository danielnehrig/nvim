local globals = require("core.global")
local sumneko_root_path = os.getenv("HOME") .. "/dotfiles/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. globals.os_name .. "/lua-language-server"
local lsp = require("plugins.lspconfig")
local lspconfig = require("lspconfig")
local capabilities = require("plugins.lspStatus").capabilities

-- Lua Settings for nvim config and plugin development
if not packer_plugins["lua-dev.nvim"].loaded then
    vim.cmd [[packadd lua-dev.nvim]]
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, "lua/plugins/?/?.lua")

local luadev =
    require("lua-dev").setup(
    {
        library = {
            vimruntime = true, -- runtime path
            types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
            plugins = true -- installed opt or start plugins in packpath
            -- you can also specify the list of plugins to make available as a workspace library
            -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        lspconfig = {
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                        -- Setup your lua path
                        path = runtime_path
                    },
                    diagnostics = {
                        globals = {"packer_plugins"}
                    }
                }
            },
            capabilities = capabilities,
            flags = {debounce_text_changes = 500},
            root_dir = require("lspconfig/util").root_pattern("."),
            on_attach = function(client, bufnr)
                client.resolved_capabilities.document_formatting = false
                lsp:on_attach(client, bufnr)
            end
        }
    }
)

lspconfig.sumneko_lua.setup(luadev)
