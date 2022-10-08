local fs = require("config.core.fs")
local linter = "eslint_d"
local command = string.format(
  "%s --no-color --format visualstudio --stdin",
  fs.executable(linter)
)
local command_fmt =
  string.format("%s --no-color --fix-to-stdout --stdin", fs.executable(linter))

return {
  prefix = linter,
  lintCommand = command,
  lintStdin = true,
  lintFormats = { "<text>(%l,%c): %trror %m", "<text>(%l,%c): %tarning %m" },
  lintIgnoreExitCode = true,
  formatCommand = command_fmt,
  formatStdin = true,
  rootMarkers = {
    ".eslintrc",
    ".eslintrc.cjs",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
  },
}
