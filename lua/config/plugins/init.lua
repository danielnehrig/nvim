local plugins = {}

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

return plugins
