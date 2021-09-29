vim.cmd([[ packadd nvim-jdtls ]])
local capabilities = require("plugins.lspconfig").capabilities
local lsp = require("plugins.lspconfig")
local map = require("utils").map

local home = require("core.global").home
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = home .. "/code/workspace/" .. workspace_dir

local bundles = {
  vim.fn.glob(
    "path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob("/path/to/microsoft/vscode-java-test/server/*.jar"),
    "\n"
  )
)

local config = {
  -- The command that starts the language server
  init_options = {
    bundles = bundles,
  },
  cmd = {
    "jdtls",
    "-data",
    workspace,
  },
  capabilities = capabilities,
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require("jdtls.setup").find_root({
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
  }),
  on_attach = function(client, bufnr)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    lsp.on_attach(client, bufnr)

    -- extra jdtls mapping overwrite TODO
    map(bufnr, "n", "<space>gf", "<cmd>lua require('jdtls').code_action()<CR>")
  end,
}
require("jdtls").start_or_attach(config)

vim.cmd([[
command! -buffer JdtCompile lua require('jdtls').compile()
command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JdtJol lua require('jdtls').jol()
command! -buffer JdtBytecode lua require('jdtls').javap()
command! -buffer JdtJshell lua require('jdtls').jshell()
]])
