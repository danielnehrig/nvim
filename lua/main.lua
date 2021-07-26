-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer config setup
-- because of lazyloading
local g = vim.g

-- disable plugins
local disabled_built_ins = {
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- check if we are in VSCode nvim
-- if not do not apply plugins
-- slows down VSCode and makes it non usable
if not g.vscode then
    -- setup conf and lua modules
    require("core.global")
    require("core.options")
    require("core.mappings")
    require("core.autocmd")

    local pack = require("packer-config")
    pack.ensure_plugins()
    pack.load_compile()

    vim.opt.shadafile = ""
end
