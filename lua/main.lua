-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer_config setup
-- because of lazloading
local g = vim.g

-- disable plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
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
    "rrhelper",
    "spellfile_plugin"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- check if we are in vscode nvim
-- if not do not apply plugins
-- slows down vscode and makes it non usable
if not g.vscode then
    -- setup conf and lua modules
    require("core.global")
    require("core.options")
    local modules = {
        "core.mappings",
        "core.autocmd",
        "packer-config"
    }
    local async
    async =
        vim.loop.new_async(
        vim.schedule_wrap(
            function()
                for i = 1, #modules, 1 do
                    local ok, res = xpcall(require, debug.traceback, modules[i])
                    if not (ok) then
                        print("Error loading module : " .. modules[i])
                        print(res) -- print stack traceback of the error
                    end
                end
                async:close()
            end
        )
    )
    async:send()
    vim.opt.shadafile = ""
end
