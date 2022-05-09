local fs = require("config.core.fs")
local formatter = "stylua"
local command = string.format("%s --color Never -", fs.executable(formatter))

return {
  formatCommand = command,
  formatStdin = true,
  rootMarkers = { "stylua.toml", ".stylua.toml" },
}
