---@module 'lazy.types'

---@class lsp
---@field lsp table<string, LazyPluginSpec>
local M = {}

M.lsp = {
  --- INFO: lsp lens integration
  ["VidocqH/lsp-lens.nvim"] = {
    event = "VeryLazy",
    opts = {},
  },
  ["scalameta/nvim-metals"] = {
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function(_, _)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end,
      },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings.serverVersion = "1.2.0"
      local capabilities =
        require("config.plugins.configs.lspconfig.capabilities").capabilities
      metals_config.capabilities = capabilities
      local lsp = require("config.plugins.configs.lspconfig")
      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        local n_present, navic = pcall(require, "nvim-navic")
        if n_present then
          if client.supports_method("textDocument/documentSymbol") then
            navic.attach(client, bufnr)
          end
        end

        lsp.on_attach(client, bufnr)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group =
        vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  --- INFO: neoconf load lsp specific infos from a conf file used for projects for instance
  ["folke/neoconf.nvim"] = {
    cmd = "Neoconf",
    opts = {},
  },
  --- INFO: lsp ts aware folding
  ["kevinhwang91/nvim-ufo"] = {
    dependencies = "kevinhwang91/promise-async",
    event = "BufRead",
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      -- global handler
      require("ufo").setup({
        fold_virt_text_handler = handler,
      })
    end,
  },
  --- INFO: lua server setup for nvim
  ["folke/neodev.nvim"] = {
    ft = "lua",
    dependencies = "neovim/nvim-lspconfig",
  },
  --- INFO: lspconfig setup core of all lsp setups
  ["neovim/nvim-lspconfig"] = {
    config = require("config.plugins.configs.lspconfig").init,
    priority = 51,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      "lsp-status.nvim",
    },
  },
  --- INFO: project wide diagnostic infos
  ["folke/trouble.nvim"] = {
    config = function()
      require("trouble").setup()
    end,
    cmd = { "Trouble" },
    dependencies = "kyazdani42/nvim-web-devicons",
  },
  --- INFO: shows lsp status loading
  ["nvim-lua/lsp-status.nvim"] = {
    lazy = true,
  },
}

return M
