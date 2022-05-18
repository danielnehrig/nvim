local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("config.core.global")
local vim_path = global.vim_path
local sep_os_replacer = require("config.utils").sep_os_replacer
local packer_compiled = vim_path .. "plugin/" .. "packer_compiled.lua"

local function init()
  local present, packer = pcall(require, "packer")
  if not present then
    vim.notify("packer is not installed")
    return
  end
  packer.reset()
  packer.init({
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
  })
  local use = packer.use

  use({ "lewis6991/impatient.nvim" })

  for _, theme in pairs(require("config.plugins.modules.themes").theme) do
    use(theme)
  end

  for _, theme in
    pairs(require("config.plugins.modules.themes").ts_themes)
  do
    use(theme.packer_cfg)
  end

  for _, utility in
    pairs(require("config.plugins.modules.utility").utility)
  do
    use(utility)
  end

  for _, git in pairs(require("config.plugins.modules.git").git) do
    use(git)
  end

  for _, ts in pairs(require("config.plugins.modules.treesitter").ts) do
    use(ts)
  end

  for _, lsp in pairs(require("config.plugins.modules.lsp").lsp) do
    use(lsp)
  end

  for _, completion in
    pairs(require("config.plugins.modules.completion").completion)
  do
    use(completion)
  end

  for _, language in
    pairs(require("config.plugins.modules.language").language)
  do
    use(language)
  end

  for _, debug in pairs(require("config.plugins.modules.debug").debug) do
    use(debug)
  end

  for _, navigation in
    pairs(require("config.plugins.modules.navigation").packer)
  do
    use(navigation)
  end

  use({ "windwp/nvim-autopairs" }) -- autopairs "" {}
  use({
    "vimwiki/vimwiki",
    cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
  })

  use({ "nvim-lua/plenary.nvim" })
  use({ "wbthomason/packer.nvim", opt = true }) -- packer
end

local plugins = {}
plugins._index = plugins

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
  local install_path = sep_os_replacer(
    fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  )
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
