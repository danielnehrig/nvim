local global = require("config.core.global")
local remap = require("config.utils").map_global
local sep_os_replacer = require("config.utils").sep_os_replacer

local init = false
_G.load_py_dap = function()
  if not packer_plugins["nvim-dap-python"].loaded and not init then
    require("config.plugins.dap.attach"):addPlug()
    vim.cmd([[ packadd nvim-dap-python ]])
    require("dap-python").setup(
      sep_os_replacer(global.dap_path .. "/python/bin/python")
    )
    init = true
  end
  require("dap").continue()
end

remap("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
