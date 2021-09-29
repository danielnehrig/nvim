local cmd = vim.cmd
local globals = require("core.global")
local path_sep = package.config:sub(1, 1)
local sumneko_root_path = globals.lsp_path .. path_sep .. "lua"
local sumneko_binary = sumneko_root_path
  .. path_sep
  .. "bin"
  .. path_sep
  .. globals.sumenko_os
  .. path_sep
  .. "lua-language-server"
local lsp = require("plugins.lspconfig")
local lspconfig = require("lspconfig")
local capabilities = require("plugins.lspconfig.capabilities").capabilities

-- Lua Settings for nvim config and plugin development
if not packer_plugins["lua-dev.nvim"].loaded then
  cmd([[packadd lua-dev.nvim]])
end

local isNvim = string.match(vim.fn.getcwd(), ".*/dotfiles.*") ~= nil and true
  or false

local luadev = require("lua-dev").setup({
  library = {
    vimruntime = isNvim, -- runtime path
    types = isNvim, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = isNvim, -- installed opt or start plugins in packpath
    nvim_cfg = isNvim,
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  lspconfig = {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
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
