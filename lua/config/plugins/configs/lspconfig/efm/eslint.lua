local fs = require("config.core.fs")
local linter = "eslint_d"
local command = string.format(
  "%s --no-color --f unix --stdin --stdin-filename ${INPUT}",
  fs.executable(linter)
)
local command_fmt = string.format(
  "%s --no-color --fix-to-stdout --stdin --stdin-filename ${INPUT}",
  fs.executable(linter)
)

return {
  lintCommand = command,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
  formatCommand = command_fmt,
  formatStdin = true,
  rootMarkers = {
    ".eslintrc",
    ".eslintrc.cjs",
    ".eslintrc.js",
    "package.json",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
  },
}
