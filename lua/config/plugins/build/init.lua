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
  if info.exit_code == 0 then
    vim.notify(info.maker.name .. " Finished Successfully", 2, opt)
  elseif info.exit_code == 1 then
    vim.notify(info.maker.name .. " Failed", 1, opt)
  else
    vim.notify(info.maker.name .. " Started", 3, opt)
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

  vim.g.neomake_lua_luacheck_maker = {
    exe = "luacheck",
    args = table.concat({
      "--no-color",
      "--globals",
      "vim",
      "packer_plugins",
      "--formatter=plain",
      "--ranges",
      "--codes",
      "--filename",
      "%:p",
    }, " "),
    errorformat = "%E%f:%l:%c-%s: \\(%t%n\\) %m",
    supports_stdin = 1,
  }

  nvim_set_var("test#strategy", "neomake")

  local au_build = vim.api.nvim_create_augroup("build_nm", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeomakeJobFinished",
    callback = function()
      require("config.plugins.build"):Finished()
    end,
    group = au_build,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeomakeJobFinished",
    callback = function()
      require("config.plugins.build").Report()
    end,
    group = au_build,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeomakeJobStarted",
    callback = function()
      require("config.plugins.build"):Start()
    end,
    group = au_build,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeomakeJobStarted",
    callback = function()
      require("config.plugins.build").Report()
    end,
    group = au_build,
  })
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
