local cmd = vim.cmd
local globals = require("config.core.global")
local sep_os_replacer = require("config.utils").sep_os_replacer
local sumneko_root_path = sep_os_replacer(globals.lsp_path .. "/lua")
local sumneko_binary = vim.fn.expand(
  sumneko_root_path .. "/bin/lua-language-server"
)
local lsp = require("config.plugins.lspconfig")
local lspconfig = require("lspconfig")
local capabilities =
  require("config.plugins.lspconfig.capabilities").capabilities
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
    cmd = {
      sumneko_binary,
      "-E",
      sep_os_replacer(sumneko_root_path .. "/main.lua"),
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
      client.resolved_capabilities.document_formatting = false
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
        sumneko_binary,
        "-E",
        sep_os_replacer(sumneko_root_path .. "/main.lua"),
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
        client.resolved_capabilities.document_formatting = false
        lsp.on_attach(client, bufnr)
      end,
    },
  })
  lspconfig.sumneko_lua.setup(luadev_reinit)
end

return M
