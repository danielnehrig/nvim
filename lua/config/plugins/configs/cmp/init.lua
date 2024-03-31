local M = {}

function M.init()
  local present, cmp = pcall(require, "cmp")
  if not present then
    vim.notify("cmp is not installed or loaded")
    return
  end

  cmp.setup({
    formatting = {
      format = function(entry, vim_item)
        local k_present, lspkind = pcall(require, "lspkind")
        if not k_present then
          vim.notify("lspkind is not installed or loaded")
          return
        end

        if entry.source.name == "copilot" then
          vim_item.kind = "[] Copilot"
          vim_item.kind_hl_group = "CmpItemKindCopilot"
          return vim_item
        end
        -- fancy icons and a name of kind
        vim_item.kind = lspkind.presets.default[vim_item.kind]
          .. " "
          .. vim_item.kind

        -- set a name for each source
        vim_item.menu = ({
          path = "[Path]",
          nvim_lsp = "[LSP]",
          copilot = "[Copilot]",
          spell = "[Spell]",
          cmdline = "[CMD]",
          cmp_git = "[GIT]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[NLua]",
          buffer = "[Buffer]",
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
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    completion = {
      keyword_length = 1,
    },
    experimental = {
      ghost_text = true,
    },
    mapping = cmp.mapping.preset.insert({
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
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
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        local present_neogen, neogen = pcall(require, "neogen")
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif present_neogen and neogen.jumpable() then
          neogen.jump_next()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<C-d>a"] = cmp.mapping(function(_)
        vim.api.nvim_feedkeys(
          vim.fn["copilot#Accept"](
            vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
          ),
          "n",
          true
        )
      end),
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
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping.complete({}),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    -- preselect = cmp.PreselectMode.Item,
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help" },
      {
        name = "luasnip",
        entry_filter = function()
          local context = require("cmp.config.context")
          return not context.in_treesitter_capture("string")
            and not context.in_syntax_group("String")
        end,
      },
      { name = "nvim_lsp" },
      { name = "path" },
    }),
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype({ "gitcommit" }, {
    sources = {
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      { name = "buffer" },
    },
  })

  cmp.setup.filetype({ "latex", "tex", "plaintex" }, {
    sources = {
      { name = "lua-latex-symbols" },
    },
  })

  cmp.setup.filetype({ "org" }, {
    sources = {
      { name = "orgmode" },
      { name = "luasnip" },
      { name = "path" },
    },
  })

  cmp.setup.filetype({ "toml", "rs" }, {
    sources = {
      { name = "luasnip" },
      { name = "crates" },
    },
  })
end

return M
