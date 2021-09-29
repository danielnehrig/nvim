require("plugins.dap.attach"):addPlug()
vim.cmd([[ packadd nvim-dap-python ]])
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
