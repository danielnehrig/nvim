local M = {}

M.init = function()
  require("which-key").add({
    { "<leader>]", group = "TS Textobj" },
    { "<leader>b", group = "Build/Run/Test" },
    { "<leader>c", group = "Commented" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "File" },
    { "<leader>g", group = "Lsp and Grammar" },
    { "<leader>h", group = "Gitsigns" },
    { "<leader>l", group = "LocList" },
    { "<leader>o", group = "Orgmode" },
    { "<leader>q", group = "QuickfixList" },
    { "<leader>t", group = "Tab Nav" },
    { "<leader>u", group = "Utils" },
  })
end

return M
