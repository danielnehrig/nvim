local dap = require "dap"

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/code/vscode-node-debug2/out/src/nodeDebug.js"}
}

vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
vim.fn.sign_define("DapStopped", {text = "🟢", texthl = "", linehl = "", numhl = ""})

dap.configurations.typescript = {
    {
        type = "node2",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector"
    }
}

dap.configurations.typescriptreact = {
    {
        type = "node2",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector"
    }
}

dap.configurations.javascript = {
    {
        type = "node2",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector"
    }
}

require("dapui").setup()
