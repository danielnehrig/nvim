-- TODO: trigger on python filetype when mapping is pressed then add dap-python
require("plugins.dap.attach"):addPlug()
vim.cmd([[ packadd nvim-dap-python ]])
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
