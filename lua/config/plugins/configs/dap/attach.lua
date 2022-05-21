local set = vim.keymap.set
local M = {}

function M.init()
  local dap_present, _ = pcall(require, "dap")
  local dapui_present, _ = pcall(require, "dapui")
  if not dap_present or not dapui_present then
    local dap_add, _ = pcall(vim.cmd, "packadd nvim-dap")
    local dapui_add, _ = pcall(vim.cmd, "packadd nvim-dap-ui")
    if dap_add and dapui_add then
      require("config.plugins.configs.dap")
      M.mappings()
    else
      vim.notify("Error adding DAP")
    end

    return
  end

  require("config.plugins.configs.dap")
  M.mappings()
end

function M.mappings()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "lua" },
    callback = function()
      require("dap.ext.autocompl").attach()
    end,
  })

  set("n", "<Leader>ds", function()
    require("dap").close()
  end)
  set("n", "<Leader>dd", function()
    require("dap").disconnect()
    require("dapui").close()
  end)
  set("n", "<Leader>dB", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end)
  set("n", "<Leader>dO", function()
    require("dap").step_over()
  end)
  set("n", "<Leader>di", function()
    require("dap").step_into()
  end)
  set("n", "<Leader>do", function()
    require("dap").step_out()
  end)
  set("n", "<Leader>dr", function()
    require("dap").repl.open()
  end)
  set("n", "<Leader>de", function()
    require("dapui").eval()
  end)
  set("n", "<Leader>df", function()
    require("dapui").float_element()
  end)
  set("n", "<Leader>dt", function()
    require("dapui").toggle()
  end)
end

function M.getStatus()
  local present, dap = pcall(require, "dap")
  if present then
    if dap then
      if dap.session() then
        if dap.session().config then
          local type = dap.session().config.type
          return type .. " ﮣ " .. dap.status()
        end
      end
      return "DAP"
    end
  end
  return nil
end

return M
