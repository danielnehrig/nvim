local M = {}

function M.init()
  if not packer_plugins["plenary.nvim"].loaded then
    vim.cmd([[packadd plenary.nvim]])
  end
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")
  require("plugins.cmp.luasnip").init()

  cmp.setup({
    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = lspkind.presets.default[vim_item.kind]
          .. " "
          .. vim_item.kind

        -- set a name for each source
        vim_item.menu = ({
          path = "[Path]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
        })[entry.source.name]
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        -- For `luasnip` user.
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        border = "rounded",
      },
      documentation = {
        border = "rounded",
      },
    },
    completion = {
      completeopt = "menu,menuone,noselect,noinsert",
      keyword_length = 1,
    },
    experimental = {
      ghost_text = true,
    },
    mapping = {
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif packer_plugins["neogen"] and packer_plugins["neogen"].loaded then
          local neogen = require("neogen")
          if neogen.jumpable() then
            neogen.jump_next()
          end
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<C-x><C-o>"] = cmp.mapping(function(_)
        cmp.complete({
          config = {
            sources = {
              { name = "nvim_lsp" },
            },
          },
        })
      end, {
        "i",
      }),
      ["<C-x><C-s>"] = cmp.mapping(function(_)
        cmp.complete({
          config = {
            sources = {
              { name = "spell" },
              -- { name = "nuspell" },
            },
          },
        })
      end, {
        "i",
      }),
      ["<C-x><C-j>"] = cmp.mapping(function(_)
        cmp.complete({
          config = {
            sources = {
              { name = "luasnip" },
            },
          },
        })
      end, {
        "i",
      }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    -- preselect = cmp.PreselectMode.Item,
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
      { name = "path" },
      { name = "orgmode" },
    },
  })

  cmp.setup.cmdline("/", {
    view = {
      entries = { name = "wildmenu", separator = "|" },
    },
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
