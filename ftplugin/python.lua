local global = require("config.core.global")
local config = require("config.core.config").config
local set = vim.keymap.set
local build_path_string = require("config.utils").build_path_string

_G.load_py_dap = function()
  local ok, _ = pcall(require, "dap-python")

  if not ok then
    require("config.plugins.configs.dap.attach").init()
    if config.ui.plugin_manager == "packer" then
      vim.cmd([[ packadd nvim-dap-python ]])
    else
      print("yes")
      require("lazy").load({ plugins = { "nvim-dap-python" } })
    end
    local ok, dap_python = pcall(require, "dap-python")
    if ok then
      dap_python.setup(
        build_path_string(global.dap_path .. "/python/bin/python")
      )
    else
      vim.notify("Failed to load dap-python")
    end
  end
  require("dap").continue()
end

set("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
