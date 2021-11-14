local remap = require("utils").map_global

local Debug = {
  dap = nil,
}

local debug = nil

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

    require("plugins.dap")
  end
end

function Debug.mappings()
  vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])
  remap("n", "<Leader>ds", [[ <Cmd>lua require'dap'.close()<CR>]])
  remap(
    "n",
    "<Leader>dd",
    [[ <Cmd>lua require'dap'.disconnect(); require("dapui").close()<CR>]]
  )
  remap(
    "n",
    "<Leader>dB",
    [[ <Cmd>lua require'dap'.set_breakpoint(nil, nul vim.fn.input('Log point message: '))<CR>]]
  )
  remap("n", "<Leader>dO", [[ <Cmd>lua require'dap'.step_over()<CR>]])
  remap("n", "<Leader>di", [[ <Cmd>lua require'dap'.step_into()<CR>]])
  remap("n", "<Leader>do", [[ <Cmd>lua require'dap'.step_out()<CR>]])
  remap("n", "<Leader>dr", [[ <Cmd>lua require'dap'.repl.open()<CR>]])
  remap("n", "<Leader>de", [[ <Cmd>lua require'dapui'.eval()<CR>]])
  remap("n", "<Leader>df", [[ <Cmd>lua require'dapui'.float_element()<CR>]])
  remap("n", "<Leader>dt", [[ <Cmd>lua require'dapui'.toggle()<CR>]])
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
      local type = self.dap.session().config.type
      return type .. " " .. self.dap.status()
    end
  end

  return "Detached"
end

if not debug then
  debug = Debug.new()
end

return debug
