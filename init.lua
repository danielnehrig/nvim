local present, impatient = pcall(require, "impatient")
local p_present, _ = pcall(require, "packer")

if present then
  impatient.enable_profile()
end

if not p_present then
  vim.cmd("packadd packer.nvim")
end

if vim.version().minor > 7 then
  local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "tutor_mode_plugin",
    "zip",
    "zipPlugin",
  }

  for _, plugin in pairs(default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
  require("config.main")
else
  vim.notify("This Config Requires vim 0.9+")
end
