local fs = require("config.core.fs")

local formatter = "dprint"
local format_command =
  string.format("%s fmt --stdin ${FILEEXT}", fs.executable(formatter))

local lint_command =
  string.format("%s check ${INPUT}", fs.executable(formatter))

return {
  prefix = formatter,
  formatCommand = format_command,
  formatStdin = true,
  lintCommand = lint_command,
  lintIgnoreExitCode = true,
  rootMarkers = {
    "dprint.json",
  },
}
