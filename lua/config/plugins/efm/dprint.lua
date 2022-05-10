local fs = require("config.core.fs")

local formatter = "dprint"
local format_command = string.format(
  "%s fmt --config --config https://dprint.dev/path/to/some/config.json --stdin ${FILEEXT}",
  fs.executable(formatter)
)

local lint_command = string.format("%s check", fs.executable(formatter))

return {
  prefix = formatter,
  formatCommand = format_command,
  lintCommand = lint_command,
  formatStdin = true,
  lintStdin = true,
  rootMarkers = {},
}
