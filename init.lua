if vim.version().minor > 6 then
  require("config.main")
else
  vim.notify("This Config Requires vim 0.7+")
end
