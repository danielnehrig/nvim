---@module 'lazy.types'

---@class language
---@field language table<string, LazyPluginSpec>
local M = {}

vim.g.languagetool_server_jar =
  "/usr/local/opt/languagetool/libexec/languagetool-server.jar"

M.language = {
  --- INFO: live  server
  --- TODO: does this still  work ?
  ["barrett-ruth/live-server.nvim"] = {
    build = "yarn global add live-server",
    config = true,
  },
  ["rhysd/vim-grammarous"] = {
    cmd = {
      "GrammarousCheck",
    },
  },
  --- INFO: java lsp stuff
  ["mfussenegger/nvim-jdtls"] = { lazy = true },
  --- INFO: rust crates info for cargo toml
  ["Saecki/crates.nvim"] = {
    ft = { "toml", "rs" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = require("config.plugins.configs.crates").init,
  },
  --- INFO: npm js package infos
  ["vuki656/package-info.nvim"] = {
    dependencies = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  },
  --- INFO: rustlang features
  ["rust-lang/rust.vim"] = { ft = { "rust", "rs" } },
  --- INFO: markdown preview
  ["iamcco/markdown-preview.nvim"] = {
    build = "cd app && yarn install",
    ft = { "markdown", "md" },
    cmd = "MarkdownPreview",
  },
  --- INFO: code snip runner
  ["michaelb/sniprun"] = {
    cmd = { "SnipRun" },
    build = "bash ./install.sh",
  },
  --- INFO: preview openapi spec swagger stuff
  ["shuntaka9576/preview-swagger.nvim"] = {
    build = "yarn install",
    ft = { "yaml", "yml" },
    cmd = "SwaggerPreview",
  },
}

return M
