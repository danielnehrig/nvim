local M = {}

function M.init()
  local ls = require("luasnip")
  local s = ls.s
  local i = ls.insert_node
  local fmt = require("luasnip.extras.fmt").fmt
  local rep = require("luasnip.extras").rep

  ls.config.setup({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,TextChangedI",
  })

  require("luasnip.loaders.from_vscode").lazy_load({})

  ls.add_snippets("lua", {
    ls.parser.parse_snippet("cb", "function($1)\n$0\nend"),
    ls.parser.parse_snippet("pr", "print(vim.inspect($1))$0"),
    s("req", fmt("local {} = require('{}')", { i(1), rep(1) })),
  })
  ls.add_snippets("javascript", {
    ls.parser.parse_snippet("cb", "($1) => {\n$0\n}"),
  })
  ls.add_snippets("typescript", {
    ls.parser.parse_snippet("cb", "($1) => {\n$0\n}"),
  })
  ls.add_snippets("typescriptreact", {
    ls.parser.parse_snippet("cb", "($1) => {\n$0\n}"),
  })
  ls.add_snippets("rust", {
    ls.parser.parse_snippet("cb", "|$1| {\n$0\n}"),
  })
end

return M
