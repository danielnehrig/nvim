return {
  name = "cargo llvm-cov",
  builder = function()
    local cmd = { "cargo", "llvm-cov" }
    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "rust" },
  },
}
