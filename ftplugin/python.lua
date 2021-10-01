local global = require("core.global")
local remap = require("utils").map_global

local init = false
_G.load_py_dap = function()
  if not packer_plugins["nvim-dap-python"].loaded and not init then
    require("plugins.dap.attach"):addPlug()
    vim.cmd([[ packadd nvim-dap-python ]])
    require("dap-python").setup(global.dap_path .. "/python/bin/python")
    init = true
  end
  require("dap").continue()
end

remap("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
