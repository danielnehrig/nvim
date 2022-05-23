local M = {}

function M.init()
  local present, ls = pcall(require, "luasnip")
  if not present then
    return
  end
  local fmt = require("luasnip.extras.fmt").fmt
  local s = ls.snippet
  local i = ls.insert_node
  local f = ls.function_node
  local d = ls.dynamic_node
  local sn = ls.snippet_node
  local rep = require("luasnip.extras").rep

  ls.config.setup({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,TextChangedI",
  })

  require("luasnip.loaders.from_vscode").lazy_load({})

  local function get_prop_names(id_node)
    local object_type_node = id_node:child(2)
    if object_type_node:type() ~= "object_type" then
      return {}
    end

    local prop_names = {}

    for prop_signature in object_type_node:iter_children() do
      if prop_signature:type() == "property_signature" then
        local prop_iden = prop_signature:child(0)
        local prop_name = vim.treesitter.query.get_node_text(prop_iden, 0)
        prop_names[#prop_names + 1] = prop_name
      end
    end

    return prop_names
  end

  ls.add_snippets("typescriptreact", {
    s(
      "c",
      fmt(
        [[
{}interface {}Props {{
  {}
}}
{}function {}({{{}}}: {}Props) {{
  {}
}}
]],
        {
          i(1, "export "),

          -- Initialize component name to file name
          d(2, function(_, snip)
            return sn(nil, {
              i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
            })
          end, { 1 }),
          i(3, "// props"),
          rep(1),
          rep(2),
          f(function(_, snip, _)
            local pos_begin = snip.nodes[6].mark:pos_begin()
            local pos_end = snip.nodes[6].mark:pos_end()
            local parser = vim.treesitter.get_parser(0, "tsx")
            local tstree = parser:parse()

            local node = tstree[1]:root():named_descendant_for_range(
              pos_begin[1],
              pos_begin[2],
              pos_end[1],
              pos_end[2]
            )

            while node ~= nil and node:type() ~= "interface_declaration" do
              node = node:parent()
            end

            if node == nil then
              return ""
            end

            -- `node` is now surely of type "interface_declaration"
            local prop_names = get_prop_names(node)

            -- Does this lua->vimscript->lua thing cause a slow down? Dunno.
            return vim.fn.join(prop_names, ", ")
          end, { 3 }),
          rep(2),
          i(5, "return <div></div>"),
        }
      )
    ),
  })

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
