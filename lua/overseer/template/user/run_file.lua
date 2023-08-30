return {
  name = "run file",
  builder = function()
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:p:r")
    local cmd = { file }
    local args = {}
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    end
    if vim.bo.filetype == "rust" then
      cmd = { outfile }
    end
    return {
      cmd = cmd,
      args = args,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "sh", "python", "go", "rust" },
  },
}
