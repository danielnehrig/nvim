-- TODO: trigger on python filetype when mapping is pressed then add dap-python
local global = require("core.global")
local remap = require("utils").map_global

_G.load_py_dap = function()
  require("plugins.dap.attach"):addPlug()
  if not packer_plugins["nvim-dap-python"].loaded then
    vim.cmd([[ packadd nvim-dap-python ]])
    require("dap-python").setup(global.dap_path .. "/python/bin/python")
  end
  require("dap").continue()
end

remap("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
