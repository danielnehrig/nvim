local Func = require("utils")

vim.g.neomake_open_list = 2

vim.api.nvim_set_var("test#javascript#runnter", "jest")
vim.api.nvim_set_var("test#javascript#jest#options", "--reporters ~/dotfiles/vim-qf-format.js")
vim.api.nvim_set_var("test#strategy", "neomake")

local Make = {
    failed = false,
    success = false,
    running = false,
    status = "Make"
}

Make.__index = Make

function Make:new(o)
    o = o or {}
    setmetatable(o, Make)
    return o
end

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

function Make:GetFailed()
    return self.failed
end

function Make:GetSuccess()
    return self.success
end

function Make:GetRunning()
    return self.running
end

local make = Make:new()

local autocmds = {
    neomake_hook = {
        {"User", "NeomakeJobFinished", "lua require('plugins.build'):Finished()"},
        {"User", "NeomakeJobStarted", "lua require('plugins.build'):Start()"}
    }
}

Func.nvim_create_augroups(autocmds)

return make
