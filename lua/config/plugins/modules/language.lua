---@module 'lazy.types'

---@class language
---@field language table<string, LazyPluginSpec>
local M = {}

vim.g.languagetool_server_jar =
  "/usr/local/opt/languagetool/libexec/languagetool-server.jar"

M.language = {
  ["barrett-ruth/live-server.nvim"] = {
    build = "yarn global add live-server",
    config = true,
  },
  ["rhysd/vim-grammarous"] = {
    cmd = {
      "GrammarousCheck",
    },
  },
  ["mfussenegger/nvim-jdtls"] = { opt = true },
  ["Saecki/crates.nvim"] = {
    ft = { "toml", "rs" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = require("config.plugins.configs.crates").init,
  },
  ["vuki656/package-info.nvim"] = {
    dependencies = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  },
  ["rust-lang/rust.vim"] = { ft = { "rust", "rs" } },
  ["iamcco/markdown-preview.nvim"] = {
    run = "cd app && yarn install",
    build = "cd app && yarn install",
    ft = { "markdown", "md" },
    cmd = "MarkdownPreview",
  },
  ["michaelb/sniprun"] = {
    cmd = { "SnipRun" },
    run = "bash ./install.sh",
    build = "bash ./install.sh",
  },
  ["shuntaka9576/preview-swagger.nvim"] = {
    run = "yarn install",
    build = "yarn install",
    ft = { "yaml", "yml" },
    cmd = "SwaggerPreview",
  },
}

return M
