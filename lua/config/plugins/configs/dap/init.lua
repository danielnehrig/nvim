local global = require("config.core.global")
local build_path_string = require("config.utils").build_path_string

local present, dap = pcall(require, "dap")

if not present then
  vim.notify("DAP not loaded")
  return
end

vim.fn.sign_define(
  "DapBreakpoint",
  { text = "🛑", texthl = "", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapStopped",
  { text = "🟢", texthl = "", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "🟡", texthl = "", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapLogPoint",
  { text = "🔵", texthl = "", linehl = "", numhl = "" }
)

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    build_path_string(
      global.dap_path .. "/jsnode/vscode-node-debug2/out/src/nodeDebug.js"
    ),
  },
}

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = {
    build_path_string(
      global.dap_path .. "/chrome/vscode-chrome-debug/out/src/chromeDebug.js"
    ),
  },
}

dap.adapters.lldb = {
  type = "executable",
  command = vim.fn.exepath("lldb-vscode"),
  name = "lldb",
}

dap.adapters.go = {
  type = "executable",
  command = "node",
  args = {
    build_path_string(global.dap_path .. "/go/vscode-go/dist/debugAdapter.js"),
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Neovim attach",
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: "))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    showLog = false,
    program = "${file}",
    dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
  },
}

dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch flutter",
    dartSdkPath = build_path_string(
      os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk/"
    ),
    flutterSdkPath = build_path_string(os.getenv("HOME") .. "/flutter"),
    program = build_path_string("${workspaceFolder}/lib/main.dart"),
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.typescript = {
  {
    type = "node2",
    name = "node attach",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
  },
  {
    type = "node2",
    name = "node launch file",
    request = "launch",
    runtimeExecutable = "node",
    runtimeArgs = { "--nolazy", "-r", "ts-node/register" },
    args = { "${file}" },
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
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
      ["webpack:///./*"] = "${webRoot}/*",
    },
  },
}

dap.configurations.typescriptreact = {
  {
    type = "chrome",
    name = "chrome attach",
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
      ["webpack:///./*"] = "${webRoot}/*",
    },
    {
      type = "node2",
      name = "node attach",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
    },
  },
}

dap.configurations.javascript = {
  {
    type = "node2",
    name = "node attach",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
  },
  {
    type = "node2",
    name = "node launch file",
    request = "launch",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
  },
  {
    type = "chrome",
    request = "attach",
    name = "chrome",
    program = "${file}",
    port = 9222,
    webRoot = "${workspaceFolder}",
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ["webpack://_N_E/./*"] = "${webRoot}/*",
      ["webpack:///./*"] = "${webRoot}/*",
    },
  },
}

dap.configurations.javascriptreact = {
  {
    type = "chrome",
    name = "chrome attach",
    request = "attach",
    program = "${file}",
    -- cwd = vim.fn.getcwd(),
    -- sourceMaps = true,
    -- protocol = "inspector",
    port = 9222,
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ["webpack://_N_E/./*"] = "${webRoot}/*",
      ["webpack:///./*"] = "${webRoot}/*",
    },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.getcwd() .. "/",
        "file"
      )
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- overwrite program
dap.configurations.rust[1].externalConsole = true
dap.configurations.rust[1].program = function()
  return build_path_string(
    vim.fn.getcwd() .. "/target/debug/" .. "${workspaceFolderBasename}"
  )
end

local dapui_present, dapui = pcall(require, "dapui")
if not dapui_present then
  vim.notify("dapui not loaded")
  return
end
dapui.setup()
