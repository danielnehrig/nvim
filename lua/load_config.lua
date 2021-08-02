-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
require("plugins.build")
require("plugins.indent-blankline")
require("plugins.bufferline")
require("plugins.statusline")
require("plugins.web-devicons")
require("plugins.which")
require("plugins.swagger")
require("plugins.autopairs")
require("plugins.nvimTree")
require("plugins.treesitter")
require("plugins.lspsaga")
require("plugins.refactoring")
require("plugins.wildmenu")
require("core.highlights")
