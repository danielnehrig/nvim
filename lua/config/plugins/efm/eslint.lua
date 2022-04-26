local linter = "eslint_d"
return {
  prefix = linter,
  lintCommand = "eslint_d --no-color --format visualstudio --stdin",
  lintStdin = true,
  lintFormats = { "<text>(%l,%c): %trror %m", "<text>(%l,%c): %tarning %m" },
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --no-color --fix-to-stdout --stdin",
  formatStdin = true,
  rootMarkers = {
    ".eslintrc",
    ".eslintrc.cjs",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "package.json",
  },
}
