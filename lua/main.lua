-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer_config setup
-- because of lazloading
local g = vim.g

-- check if we are in vscode nvim
-- if not do not apply plugins
-- slows down vscode and makes it non usable
if not g.vscode then
    -- setup conf and lua modules
    require("core.global")
    require("core.options")
    require("core.mappings")
    require("core.autocmd")

    -- load packer plugins
    local pack = require("packer-config")
    pack.ensure_plugins()
    pack.load_compile()
end
