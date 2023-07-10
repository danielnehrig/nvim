local global = require("config.core.global")
local set = vim.keymap.set
local build_path_string = require("config.utils").build_path_string

local init = false
_G.load_py_dap = function()
  local ok, dap_python = pcall(require, "dap-python")
  if not ok and not init then
    require("config.plugins.configs.dap.attach").init()
    require("lazy").load({ plugins = { "mfussenegger/nvim-dap-python" } })
    init = true
  end
  dap_python.setup(build_path_string(global.dap_path .. "/python/bin/python"))
  require("dap").continue()
end

set("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
