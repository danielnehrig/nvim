-- TODO: trigger on python filetype when mapping is pressed then add dap-python
local dap_install_folder = vim.fn.stdpath("data") .. "/dapinstall/"
require("plugins.dap.attach"):addPlug()
vim.cmd([[ packadd nvim-dap-python ]])
require("dap-python").setup(dap_install_folder .. "python/bin/python")
