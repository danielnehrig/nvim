local global = require("config.core.global")
local set = vim.keymap.set
local build_path_string = require("config.utils").build_path_string

local init = false
_G.load_py_dap = function()
  if not packer_plugins["nvim-dap-python"].loaded and not init then
    require("config.plugins.configs.dap.attach").init()
    vim.cmd([[ packadd nvim-dap-python ]])
    require("dap-python").setup(
      build_path_string(global.dap_path .. "/python/bin/python")
    )
    init = true
  end
  require("dap").continue()
end

set("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
