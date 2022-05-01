local set = vim.keymap.set

local Debug = {
  dap = nil,
}

local debug_instance = nil

Debug.__index = Debug

function Debug.new(o)
  o = o or {}
  setmetatable(o, Debug)
  return o
end

function Debug:addPlug()
  if not packer_plugins["nvim-dap"].loaded then
    vim.cmd([[packadd nvim-dap]])
    vim.cmd([[packadd nvim-dap-ui]])
    self.dap = require("dap")
    self.mappings()

    require("config.plugins.dap")
  end
end

function Debug.mappings()
  vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])
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

function Debug:attach()
  if self.dap then
    self.dap.continue()
  end
end

function Debug:session()
  if self.dap then
    if self.dap.session() then
      return true
    end
  end

  return false
end

function Debug:getStatus()
  if self.dap then
    if self.dap.session() then
      if self.dap.session().config then
        local type = self.dap.session().config.type
        return type .. " " .. self.dap.status()
      end
    end
  end

  return "Detached"
end

if not debug_instance then
  debug_instance = Debug.new()
end

return debug_instance
