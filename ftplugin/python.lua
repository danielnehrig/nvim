-- TODO: trigger on python filetype when mapping is pressed then add dap-python
require("plugins.dap.attach"):addPlug()
local global = require("core.global")
vim.cmd([[ packadd nvim-dap-python ]])
require("dap-python").setup(global.dap_path .. "/python/bin/python")
