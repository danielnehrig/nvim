local fs = require("config.core.fs")

local cli = "rslint"
local command = string.format("%s --no-color -q -", fs.executable(cli))

return {
  prefix = cli,
  lintCommand = command,
  lintStdin = true,
  lintFormats = { "<text>(%l,%c): %trror %m", "<text>(%l,%c): %tarning %m" },
  lintIgnoreExitCode = true,
  formatCommand = "rslint - -F short",
  formatStdin = true,
  rootMarkers = {
    "rslintrc.toml",
    "rslintrc.json",
  },
}
