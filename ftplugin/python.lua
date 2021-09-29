vim.cmd([[ packadd dap-python ]])
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
