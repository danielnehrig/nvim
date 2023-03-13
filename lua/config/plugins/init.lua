local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("config.core.global")
local vim_path = global.vim_path
local build_path_string = require("config.utils").build_path_string
local packer_compiled = vim_path .. "plugin/" .. "packer_compiled.lua"

local function init()
  local present, packer = pcall(require, "packer")
  if not present then
    vim.notify("packer is not installed")
    return
  end

  local util = require('packer.util')
  local packer_options = {
    compile_path = util.join_paths(vim.fn.stdpath('data'), 'plugin', 'packer_compiled.lua'),
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

  use({ "lewis6991/impatient.nvim" })

  for _, plugin in pairs(require("config.plugins.modules").plugins) do
    use(plugin)
  end

  use({ "nvim-lua/plenary.nvim" })
  use({ "wbthomason/packer.nvim", opt = true }) -- packer
end

local plugins = {}
plugins._index = plugins

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
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
    init()

    -- install packer plugins
    packer.sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init()
    require("config.load_config").init()
  end
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if fn.filereadable(packer_compiled) ~= 1 then
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end
  local packer = require("packer")
  packer.make_commands()
end

return plugins
