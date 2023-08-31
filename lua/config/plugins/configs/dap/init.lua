local global = require("config.core.global")
local build_path_string = require("config.utils").build_path_string

local present, dap = pcall(require, "dap")

if not present then
  vim.notify("DAP not loaded")
  return
end

local present2, _ = pcall(require, "overseer")
if not present2 then
  require("dap.ext.vscode").json_decode = require("overseer.json").decode
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
  command = build_path_string(global.dap_path .. "/node-debug2-adapter"),
}

dap.adapters.chrome = {
  type = "executable",
  command = build_path_string(global.dap_path .. "/chrome-debug-adapter"),
}

dap.adapters.lldb = {
  type = "executable",
  command = vim.fn.exepath("lldb-vscode"),
  name = "lldb",
}

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = vim.fn.exepath("codelldb"),
    args = { "--port", "${port}" },
  },
}

dap.adapters.go = {
  type = "executable",
  command = build_path_string(global.dap_path .. "/go-debug-adapter"),
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
  {
    type = "node2",
    name = "node attach",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
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
dap.configurations.rust[1].name = "Build and Launch Project"
dap.configurations.rust[1].externalConsole = true
dap.configurations.rust[1].preLaunchTask = "cargo build"
dap.configurations.rust[1].program = function()
  local TOML = require("config.utils.toml")
  local cargotoml = vim.fn.readblob(vim.fn.getcwd() .. "/Cargo.toml")
  local parsed = TOML.parse(cargotoml)
  return build_path_string(
    vim.fn.getcwd() .. "/target/debug/" .. parsed.package.name
  )
end

dap.configurations.rust[2] = {
  name = "Launch Project",
  type = "codelldb",
  request = "launch",
  program = function()
    local TOML = require("config.utils.toml")
    local cargotoml = vim.fn.readblob(vim.fn.getcwd() .. "/Cargo.toml")
    local parsed = TOML.parse(cargotoml)
    return build_path_string(
      vim.fn.getcwd() .. "/target/debug/" .. parsed.package.name
    )
  end,
  cwd = "${workspaceFolder}",
  stopOnEntry = false,
  args = {},
  runInTerminal = false,
}

dap.configurations.rust[3] = {
  name = "Build and Launch this file",
  type = "codelldb",
  request = "launch",
  preLaunchTask = "build file",
  program = function()
    local filename = vim.api.nvim_buf_get_name(0)
    filename = string.gsub(filename, ".rs", "")
    return build_path_string(filename)
  end,
  cwd = "${workspaceFolder}",
  stopOnEntry = false,
  args = {},
  runInTerminal = false,
}

local dapui_present, dapui = pcall(require, "dapui")
local dapvt_present, dapvt = pcall(require, "nvim-dap-virtual-text")
if not dapui_present then
  vim.notify("dapui not loaded")
else
  dapui.setup()
end
if not dapvt_present then
  vim.notify("dapvt not loaded")
else
  dapvt.setup({})
end
