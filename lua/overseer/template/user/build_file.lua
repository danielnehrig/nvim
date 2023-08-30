return {
  name = "build file",
  builder = function()
    local file = vim.fn.expand("%:p")
    local cmd = { file }
    if vim.bo.filetype == "rust" then
      cmd = { "rustc" }
    end
    return {
      cmd = cmd,
      args = { "-g", file },
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
