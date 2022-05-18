local M = {}

M.language = {
  { "mfussenegger/nvim-jdtls", opt = true },
  {
    "Saecki/crates.nvim",
    ft = { "toml", "rs" },
    requires = { "nvim-lua/plenary.nvim" },
    config = require("config.plugins.configs.crates").init,
  },

  {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  },
  { "rust-lang/rust.vim", ft = { "rust", "rs" } },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = { "markdown", "md" },
    cmd = "MarkdownPreview",
  },
  {
    "metakirby5/codi.vim",
    cmd = { "Codi" },
    ft = { "javascript", "typescript", "lua" },
  },
  {
    "shuntaka9576/preview-swagger.nvim",
    run = "yarn install",
    ft = { "yaml", "yml" },
    cmd = "SwaggerPreview",
  },
}

return M
