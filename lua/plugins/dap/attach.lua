local function addPlug()
    if not packer_plugins["nvim-dap"].loaded then
        vim.cmd [[packadd nvim-dap]]
        vim.cmd [[packadd nvim-dap-ui]]
        require("plugins.dap")
    end
end

local function attach()
    addPlug()
    local dap = require "dap"
    dap.continue()
end

return {
    attach = attach,
    addPlug = addPlug
}
