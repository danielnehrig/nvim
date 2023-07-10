local global = require("config.core.global")
local config = require("config.core.config").config
local set = vim.keymap.set
local build_path_string = require("config.utils").build_path_string

local init = false
_G.load_py_dap = function()
  local ok, _ = pcall(require, "dap-python")

  if not ok and not init then
    require("config.plugins.configs.dap.attach").init()
    if config.ui.plugin_manager == "packer" then
      vim.cmd([[ packadd nvim-dap-python ]])
    else
      require("lazy").load({ plugins = { "nvim-dap-python" } })
    end
    local _, dap_python = pcall(require, "dap-python")
    dap_python.setup(build_path_string(global.dap_path .. "/python/bin/python"))
    init = true
  end
  require("dap").continue()
end

set("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
