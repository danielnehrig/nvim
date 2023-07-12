require("config.plugins.configs.dap.attach").init()
local global = require("config.core.global")
local build_path_string = require("config.utils").build_path_string
local capabilities = require("config.plugins.configs.lspconfig").capabilities
local lsp = require("config.plugins.configs.lspconfig")
local map = vim.keymap.set

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace =
  build_path_string(global.home .. "/code/workspace/" .. workspace_dir)

local bundles = {
  vim.fn.glob(
    build_path_string(
      global.dap_path
        .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    )
  ),
}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(
      build_path_string(global.dap_path .. "/vscode-java-test/server/*.jar")
    ),
    "\n"
  )
)

local config = require("config.core.config").config
local ok, _ = pcall(require, "jdtls")
if not ok then
  if config.ui.plugin_manager == "packer" then
    vim.cmd([[ packadd nvim-jdtls ]])
  else
    require("lazy").load({ plugins = { "nvim-jdtls" } })
  end
end
local jd_config = {
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

require("jdtls").start_or_attach(jd_config)
