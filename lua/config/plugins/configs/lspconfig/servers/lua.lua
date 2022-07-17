local cmd = vim.cmd
local lsp = require("config.plugins.configs.lspconfig")
local lspconfig = require("lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
local M = {}

-- Lua Settings for nvim config and plugin development
if not packer_plugins["lua-dev.nvim"].loaded then
  cmd([[packadd lua-dev.nvim]])
end

IS_NVIM = string.match(vim.fn.getcwd(), ".*/dotfiles.*") ~= nil and true
  or false

local luadev = require("lua-dev").setup({
  library = {
    vimruntime = IS_NVIM, -- runtime path
    types = IS_NVIM, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = IS_NVIM, -- installed opt or start plugins in packpath
    nvim_cfg = IS_NVIM,
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  lspconfig = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "packer_plugins", "vim" },
        },
      },
    },
    capabilities = capabilities,
    flags = { debounce_text_changes = 500 },
    -- root_dir = require("lspconfig/util").root_pattern("."),
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      local n_present, navic = pcall(require, "nvim-navic")
      if n_present then
        if client.supports_method("textDocument/documentSymbol") then
          navic.attach(client, bufnr)
        end
      end
      lsp.on_attach(client, bufnr)
    end,
  },
})

lspconfig.sumneko_lua.setup(luadev)

function M.reinit()
  IS_NVIM = string.match(vim.fn.getcwd(), ".*/dotfiles.*") ~= nil and true
    or false

  local luadev_reinit = require("lua-dev").setup({
    library = {
      vimruntime = IS_NVIM, -- runtime path
      types = IS_NVIM, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins = IS_NVIM, -- installed opt or start plugins in packpath
      nvim_cfg = IS_NVIM,
      -- you can also specify the list of plugins to make available as a workspace library
      -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    lspconfig = {
      cmd = {
        "lua-language-server",
      },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "packer_plugins" },
          },
        },
      },
      capabilities = capabilities,
      flags = { debounce_text_changes = 500 },
      -- root_dir = require("lspconfig/util").root_pattern("."),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        local n_present, navic = pcall(require, "nvim-navic")
        if n_present then
          if client.supports_method("textDocument/documentSymbol") then
            navic.attach(client, bufnr)
          end
        end
        lsp.on_attach(client, bufnr)
      end,
    },
  })
  lspconfig.sumneko_lua.setup(luadev_reinit)
end

return M
