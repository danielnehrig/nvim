local global = require("config.core.global")
local set = vim.keymap.set
local build_path_string = require("config.utils").build_path_string

_G.load_py_dap = function()
  local ok, dap_python = pcall(require, "dap-python")

  if not ok then
    require("config.plugins.configs.dap.attach").init()
    require("lazy").load({ plugins = { "nvim-dap-python" } })

    local dap_python2 = pcall(require, "dap-python")
    if ok then
      dap_python2.setup(
        build_path_string(global.dap_path .. "/python/bin/python")
      )
    else
      vim.notify("Failed to load dap-python")
    end
  else
    dap_python.setup(build_path_string(global.dap_path .. "/python/bin/python"))
  end
  require("dap").continue()
end

set("n", "<Leader>dc", [[ <Cmd>lua load_py_dap()<CR>]])
