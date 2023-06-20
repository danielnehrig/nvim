local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("config.core.global")
local vim_path = global.vim_path
local build_path_string = require("config.utils").build_path_string
local packer_compiled = vim_path .. "plugin/" .. "packer_compiled.lua"

local function init_packer()
  local present, packer = pcall(require, "packer")
  if not present then
    vim.notify("packer is not installed")
    return
  end

  local util = require("packer.util")
  local packer_options = {
    compile_path = util.join_paths(
      vim.fn.stdpath("data"),
      "plugin",
      "packer_compiled.lua"
    ),
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "double" })
      end,
    },
    git = {
      clone_timeout = 6000, -- seconds
    },
    auto_clean = true,
    compile_on_sync = true,
    snapshot = nil,
  }

  packer.reset()
  packer.init(packer_options)

  local use = packer.use

  for _, plugin in pairs(require("config.plugins.modules").plugins) do
    use(plugin)
  end

  use({ "wbthomason/packer.nvim", opt = true }) -- packer
end

local plugins = {}
plugins._index = plugins

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.packer_bootstrap()
  local install_path =
    build_path_string(fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim")
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    execute("packadd packer.nvim")
    local packer = require("packer")

    -- load packer plugins
    init_packer()

    -- install packer plugins
    packer.sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init_packer()
    require("config.load_config").init()
  end
end

local function init_lazy()
  require("lazy").setup(require("config.plugins.modules").plugins, {})
end

function plugins.lazy_bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  init_lazy()
  require("config.load_config").init()
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if fn.filereadable(packer_compiled) ~= 1 then
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end
  require("packer_compiled")
  local packer = require("packer")
  packer.make_commands()
end

return plugins
