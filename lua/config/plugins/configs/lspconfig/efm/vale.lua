local fs = require("config.core.fs")
local linter = "vale"
local command = string.format(
  "%s --output=%s",
  fs.executable(linter),
  vim.fn.expand("~/.config/nvim/utils/linter-config/output.tmpl")
)

return {
  prefix = linter,
  lintCommand = command,
  lintStdin = true,
  lintFormats = { "%f:%l:%c:%trror:%m", "%f:%l:%c:%tarning:%m" },
  lintIgnoreExitCode = true,
  rootMarkers = {
    ".vale.ini",
  },
}
