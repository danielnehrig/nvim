local present, impatient = pcall(require, "impatient")

if present then
  impatient.enable_profile()
end

if vim.version().minor > 7 then
  require("config.main")
else
  vim.notify("This Config Requires vim 0.8+")
end
