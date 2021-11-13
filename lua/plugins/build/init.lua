local Func = require("utils")
local cmd = vim.cmd
local nvim_set_var = vim.api.nvim_set_var

local Make = {
  failed = false,
  success = false,
  running = false,
  status = " Make  ",
  notify = nil,
}

Make.__index = Make

function Make.new(o)
  o = o or {}
  setmetatable(o, Make)
  return o
end

function Make.Report()
  local context = vim.g.neomake_hook_context
  local info = context.jobinfo
  local opt = {
    title = "Neomake",
  }
  local notify = nil
  if not packer_plugins["nvim-notify"].loaded then
    cmd([[packadd nvim-notify]])
    notify = require("notify")
    notify.setup({
      -- Animation style (see below for details)
      -- stages = "fade",
      -- Default timeout for notifications
      timeout = 3000,
      -- For stages that change opacity this is treated as the highlight behind the window
      background_colour = "NotifyBG",
      -- Icons for the different levels
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
  end
  if info.exit_code == 0 then
    notify(info.maker.name .. " Finished Successfully", "info", opt)
  elseif info.exit_code == 1 then
    notify(info.maker.name .. " Failed", "error", opt)
  else
    notify(info.maker.name .. " Started", "log", opt)
  end
end

function Make.init()
  vim.g.neomake_open_list = 2
  nvim_set_var("test#javascript#runner", "jest")
  nvim_set_var("test#typescript#runner", "jest")
  nvim_set_var("test#typescriptreact#runner", "jest")
  nvim_set_var("test#python#pytest#options", "--color=yes")
  nvim_set_var("test#javascript#jest#options", "--color=yes")
  nvim_set_var("test#typescript#jest#options", "--color=yes")
  nvim_set_var("test#typescriptreact#jest#options", "--color=yes")

  nvim_set_var("test#strategy", "neomake")

  local autocmds = {
    neomake_hook = {
      {
        "User",
        "NeomakeJobFinished",
        "lua require('plugins.build'):Finished()",
      },
      {
        "User",
        "NeomakeJobFinished",
        "lua require('plugins.build').Report()",
      },
      {
        "User",
        "NeomakeJobStarted",
        "lua require('plugins.build'):Start()",
      },
      {
        "User",
        "NeomakeJobStarted",
        "lua require('plugins.build').Report()",
      },
    },
  }

  Func.nvim_create_augroups(autocmds)
end

-- For Statusline gets called every tick
function Make:Status()
  return self.status
end

function Make:Finished()
  local info = vim.g.neomake_hook_context.jobinfo
  self.running = false
  if info.exit_code == 0 then
    self.success = true
    self.failed = false
    self.status = " " .. info.maker.name .. " ✅"
  else
    self.success = false
    self.failed = true
    self.status = " " .. info.maker.name .. " ❌"
  end
end

function Make:Start()
  local context = vim.g.neomake_hook_context
  local info = context.jobinfo
  self.status = " " .. info.maker.name .. " pip  "
  self.running = true
  self.failed = false
  self.success = false
end

-- For Statusline gets called every tick
function Make:GetFailed()
  return self.failed
end

-- For Statusline gets called every tick
function Make:GetSuccess()
  return self.success
end

-- For Statusline gets called every tick
function Make:GetRunning()
  return self.running
end

local make = Make:new()

return make
