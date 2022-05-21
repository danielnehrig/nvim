local fs = require("config.core.fs")

local formatter = "prettier"
local format_command = string.format(
  "%s --find-config-path --stdin-filepath ${INPUT}",
  fs.executable(formatter)
)

return {
  prefix = formatter,
  formatCOmmand = format_command,
  formatStdin = true,
  rootMarkers = {},
}
