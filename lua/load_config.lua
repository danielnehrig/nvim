local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
    require("plugins.web-devicons")
    require("plugins.which")
    require("plugins.swagger")
    require("plugins.autopairs")
    require("plugins.nvimTree")
    require("plugins.treesitter")
    require("plugins.lspsaga")
    require("plugins.refactoring")
    require("plugins.wildmenu")
    require("plugins.build"):init()
    require("plugins.bufferline")
    require("core.highlights")
end

return M
