local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

function M.init()
  if not packer_plugins["plenary.nvim"].loaded then
    vim.cmd([[packadd plenary.nvim]])
  end
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local neogen = require("neogen")

  cmp.setup({
    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = lspkind.presets.default[vim_item.kind]
          .. " "
          .. vim_item.kind

        -- set a name for each source
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        -- For `luasnip` user.
        require("luasnip").lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    mapping = {
      ["<tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(t("<C-n>"), "n")
        elseif neogen.jumpable() then
          vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<CR>"), "")
        elseif check_back_space() then
          vim.fn.feedkeys(t("<tab>"), "n")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "orgmode" },
      { name = "crates" },
    },
  })

  require("nvim-autopairs.completion.cmp").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    auto_select = true, -- automatically select the first item
    insert = false, -- use insert confirm behavior instead of replace
    map_char = { -- modifies the function or method delimiter by filetypes
      all = "(",
      tex = "{",
    },
  })
end

return M
