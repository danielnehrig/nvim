local Debug = {
    dap = nil
}

Debug.__index = Debug

function Debug:new(o)
    o = o or {}
    setmetatable(o, Debug)
    return o
end

function Debug:addPlug()
    if not packer_plugins["nvim-dap"].loaded then
        vim.cmd [[packadd nvim-dap]]
        vim.cmd [[packadd nvim-dap-ui]]
        self.dap = require "dap"
        require("plugins.dap")
    end
end

function Debug:attach()
    if not self.dap then
        self.addPlug()
    end
    self.dap.continue()
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
            return type .. " Attached " .. self.dap.status()
        end
    end

    return "Detached"
end

local debug = Debug:new()

return debug
