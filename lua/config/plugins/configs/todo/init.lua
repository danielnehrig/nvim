local M = {}

function M.init()
  local present, todo = pcall(require, "todo-comments")
  if not present then
    vim.notify("Todo comments not installed")
    return
  end

  todo.setup({
    signs = true, -- show icons in the signs column
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
    highlight = {
      before = "",
      keyword = "wide",
      after = "fg",
    },
    colors = {
      error = { "DiagnosticsError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticsWarning", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticsInformation", "#2563EB" },
      hint = { "DiagnosticsHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
  })
end

return M
