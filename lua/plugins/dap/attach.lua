local dap = nil

local function addPlug()
    if not packer_plugins["nvim-dap"].loaded then
        vim.cmd [[packadd nvim-dap]]
        vim.cmd [[packadd nvim-dap-ui]]
        require("plugins.dap")
    end
end

local function attach()
    if not dap then
        addPlug()
        dap = require "dap"
    end
    dap.continue()
end

local function getStatus()
    if dap then
        if dap.session() then
            return "DAP Attached"
        end
    end

    return ""
end

return {
    attach = attach,
    addPlug = addPlug,
    getStatus = getStatus
}
