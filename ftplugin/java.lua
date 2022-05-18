require("config.plugins.configs.dap.attach"):addPlug()
local global = require("config.core.global")
local sep_os_replacer = require("config.utils").sep_os_replacer
local capabilities = require("config.plugins.configs.lspconfig").capabilities
local lsp = require("config.plugins.configs.lspconfig")
local map = vim.keymap.set

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = sep_os_replacer(
  global.home .. "/code/workspace/" .. workspace_dir
)

local bundles = {
  vim.fn.glob(
    sep_os_replacer(
      global.dap_path
        .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    )
  ),
}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(
      sep_os_replacer(global.dap_path .. "/vscode-java-test/server/*.jar")
    ),
    "\n"
  )
)

vim.cmd([[ packadd nvim-jdtls ]])
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
    map("n", "<space>gf", require("jdtls").code_action, { buffer = bufnr })
    map(
      "n",
      "<space>dm",
      require("jdtls").test_nearest_method,
      { buffer = bufnr }
    )
    map("n", "<space>dM", require("jdtls").test_class, { buffer = bufnr })
    map("v", "<space>em", require("jdtls").extract_method, { buffer = bufnr })
  end,
}

require("jdtls").start_or_attach(config)
