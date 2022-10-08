local M = {}

M.lsp = {
  ["kevinhwang91/nvim-ufo"] = {
    requires = "kevinhwang91/promise-async",
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
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
            -- str width returned from truncate() may less than 2rd argument, need padding
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

      -- buffer scope handler
      -- will override global handler if it is existed
      --  local bufnr = vim.api.nvim_get_current_buf()
      --  require("ufo").setVirtTextHandler(bufnr, handler)
    end,
  },
  ["folke/lsp-colors.nvim"] = {
    config = function()
      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981",
      })
    end,
  },
  ["folke/lua-dev.nvim"] = { opt = true }, -- lua nvim setup
  ["neovim/nvim-lspconfig"] = {
    config = require("config.plugins.configs.lspconfig").init,
  },
  ["folke/trouble.nvim"] = {
    config = function()
      require("trouble").setup()
    end,
    cmd = { "Trouble" },
    requires = "kyazdani42/nvim-web-devicons",
  },
  ["tomtomjhj/lsp-status.nvim"] = {
    branch = "deprecated",
  },
}

return M
