require("plugins.dap.attach"):addPlug()
vim.cmd([[ packadd nvim-jdtls ]])
local global = require("core.global")
local capabilities = require("plugins.lspconfig").capabilities
local lsp = require("plugins.lspconfig")
local map = require("utils").map

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = global.home .. "/code/workspace/" .. workspace_dir

local bundles = {
  vim.fn.glob(
    global.dap_path
      .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(global.dap_path .. "/vscode-java-test/server/*.jar"),
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
    require("jdtls.setup").add_commands()

    lsp.on_attach(client, bufnr)

    -- extra jdtls mapping overwrite TODO
    map(bufnr, "n", "<space>gf", "<cmd>lua require('jdtls').code_action()<CR>")
  end,
}

require("jdtls").start_or_attach(config)
