local M = {}

function M.init()
  local types = require("luasnip.util.types")
  require("luasnip.config").setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "GruvboxOrange" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "GruvboxBlue" } },
        },
      },
    },
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,TextChangedI",
  })

  require("luasnip.loaders.from_vscode").lazy_load({})
end

return M
