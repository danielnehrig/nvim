local dap = require "dap"
local global = require("core.global")
local dap_install_folder = vim.fn.stdpath("data") .. "/dapinstall/"

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = {dap_install_folder .. "jsnode/vscode-node-debug2/out/src/nodeDebug.js"}
}

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {dap_install_folder .. "chrome/vscode-chrome-debug/out/src/chromeDebug.js"}
}

dap.adapters.lldb = {
    type = "executable",
    command = vim.fn.exepath("lldb-vscode"),
    name = "lldb"
}

-- TODO
dap.adapters.dart = {
    type = "executable",
    command = "node",
    args = {"<path-to-Dart-Code>/out/dist/debug.js", "flutter"}
}

dap.adapters.go = {
    type = "executable",
    command = "node",
    args = {dap_install_folder .. "go/vscode-go/dist/debugAdapter.js"}
}

vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
vim.fn.sign_define("DapStopped", {text = "🟢", texthl = "", linehl = "", numhl = ""})

dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        showLog = false,
        program = "${file}",
        dlvToolPath = vim.fn.exepath("dlv") -- Adjust to where delve is installed
    }
}

dap.configurations.dart = {
    {
        type = "dart",
        request = "launch",
        name = "Launch flutter",
        dartSdkPath = os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk/",
        flutterSdkPath = os.getenv("HOME") .. "/flutter",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}"
    }
}

dap.configurations.typescript = {
    {
        type = "node2",
        name = "node",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector"
    },
    {
        type = "chrome",
        name = "chrome",
        request = "attach",
        program = "${file}",
        -- cwd = "${workspaceFolder}",
        -- protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
        -- sourceMaps = true,
        sourceMapPathOverrides = {
            -- Sourcemap override for nextjs
            ["webpack://_N_E/./*"] = "${webRoot}/*",
            ["webpack://typescript-*/./*"] = "${webRoot}/*",
            ["webpack:///./*"] = "${webRoot}/*"
        }
    }
}

dap.configurations.typescriptreact = {
    {
        type = "chrome",
        request = "attach",
        name = "chrome",
        program = "${file}",
        -- cwd = "${workspaceFolder}",
        -- protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
        -- sourceMaps = true,
        sourceMapPathOverrides = {
            -- Sourcemap override for nextjs
            ["webpack://_N_E/./*"] = "${webRoot}/*",
            ["webpack://typescript-/./*"] = "${webRoot}/*",
            ["webpack:///./*"] = "${webRoot}/*"
        }
    }
}

dap.configurations.javascript = {
    {
        type = "node2",
        name = "node",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector"
    },
    {
        type = "chrome",
        request = "attach",
        name = "chrome",
        program = "${file}",
        -- cwd = "${workspaceFolder}",
        -- protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
        -- sourceMaps = true,
        sourceMapPathOverrides = {
            -- Sourcemap override for nextjs
            ["webpack://_N_E/./*"] = "${webRoot}/*",
            ["webpack://typescript-*/./*"] = "${webRoot}/*",
            ["webpack:///./*"] = "${webRoot}/*"
        }
    }
}

dap.configurations.javascriptreact = {
    {
        type = "chrome",
        name = "chrome",
        request = "attach",
        program = "${file}",
        -- cwd = vim.fn.getcwd(),
        -- sourceMaps = true,
        -- protocol = "inspector",
        port = 9222,
        sourceMapPathOverrides = {
            -- Sourcemap override for nextjs
            ["webpack://_N_E/./*"] = "${webRoot}/*",
            ["webpack://typescript-*/./*"] = "${webRoot}/*",
            ["webpack:///./*"] = "${webRoot}/*"
        }
    }
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = false
    }
}

-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- overwrite program
dap.configurations.rust[1].program = function()
    -- root path
    return vim.fn.getcwd() .. "/target/debug/" .. "${workspaceFolderBasename}"
end

require("dapui").setup()
