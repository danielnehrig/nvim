local M = {}

M.init = function()
  local present, which = pcall(require, "which-key")

  if not present then
    return
  end

  which.setup({})
  which.register({
    g = {
      name = "Lsp and Grammar",
    },
    f = {
      name = "File",
    },
    u = {
      name = "Utils",
    },
    d = {
      name = "Debug",
    },
    q = {
      name = "QuickfixList",
    },
    h = {
      name = "Gitsigns",
    },
    l = {
      name = "LocList",
    },
    m = {
      name = "Make Test",
    },
    o = {
      name = "Orgmode",
    },
    ["]"] = {
      name = "TS Textobj",
    },
    ["c"] = {
      name = "Commented",
    },
    t = {
      name = "Tab Nav",
    },
  }, { prefix = "<leader>" })
end

return M
