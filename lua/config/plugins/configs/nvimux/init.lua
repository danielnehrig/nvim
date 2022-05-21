local M = {}

function M.init()
  local present, nvimux = pcall(require, "nvimux")
  if not present then
    return
  end
  nvimux.setup({
    config = {
      prefix = "<C-a>",
    },
    bindings = {
      { { "n", "v", "i", "t" }, "s", nvimux.commands.horizontal_split },
      { { "n", "v", "i", "t" }, "v", nvimux.commands.vertical_split },
    },
  })
end

return M
