local Func = require("utils")
local global = require("core.global")

local Make = {
    failed = false,
    success = false,
    running = false,
    status = "Make",
    notify = nil
}

Make.__index = Make

function Make:new(o)
    o = o or {}
    setmetatable(o, Make)
    return o
end

function Make:Report(msg)
    vim.cmd [[packadd nvim-notify]]
    local opt = {
        title = "Neomake"
    }
    local info = vim.g.neomake_hook_context.jobinfo
    local notify = require("notify")
    if info.exit_code == 0 then
        notify("Job Finished Successfully", _, opt)
    elseif info.exit_code == 1 then
        notify("Job Failed", "error", opt)
    else
        notify("Job Started", "log", opt)
    end
end

function Make:init()
    print("init neomake")
    vim.g.neomake_open_list = 2
    vim.api.nvim_set_var("test#javascript#runner", "jest")
    vim.api.nvim_set_var("test#typescript#runner", "jest")
    vim.api.nvim_set_var("test#typescriptreact#runner", "jest")
    vim.api.nvim_set_var("test#python#pytest#options", "--color=yes")
    vim.api.nvim_set_var("test#javascript#jest#options", "--color=yes")
    vim.api.nvim_set_var("test#typescript#jest#options", "--color=yes")
    vim.api.nvim_set_var("test#typescriptreact#jest#options", "--color=yes")

    vim.api.nvim_set_var("test#strategy", "neomake")

    local autocmds = {
        neomake_hook = {
            {"User", "NeomakeJobFinished", "lua require('plugins.build'):Finished()"},
            {"User", "NeomakeJobFinished", "lua require('plugins.build'):Report()"},
            {"User", "NeomakeJobStarted", "lua require('plugins.build'):Start()"},
            {"User", "NeomakeJobStarted", "lua require('plugins.build'):Report()"}
        }
    }

    Func.nvim_create_augroups(autocmds)
end

-- For Statusline gets called every tick
function Make:Status()
    return self.status
end

function Make:Finished()
    local context = vim.api.nvim_get_var("neomake_hook_context")
    self.running = false
    if context.jobinfo.exit_code == 0 then
        self.success = true
        self.failed = false
        self.status = "Make ✅"
    else
        self.success = false
        self.failed = true
        self.status = "Make ❌"
    end
end

function Make:Start()
    self.status = "Make"
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
