local Func = require("config.utils")
local M = {}

function M.autocmds()
  local au_utils = vim.api.nvim_create_augroup("utils", { clear = true })
  local au_ft = vim.api.nvim_create_augroup("ft", { clear = true })
  local au_cmp = vim.api.nvim_create_augroup("cmp", { clear = true })

  -- util
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      Func.open_diag_float()
    end,
    group = au_utils,
  })
  -- ft
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown,org,txt,tex",
    callback = function()
      vim.wo.spell = true
    end,
    group = au_ft,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    command = "set showtabline=0",
    group = au_ft,
  })
  -- lsp
  vim.api.nvim_create_augroup("LSP_Highlight", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = "LSP_Highlight",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        if client.supports_method("textDocument/documentHighlight") then
          local au_lsp = vim.api.nvim_create_augroup("LSPDocumentHighlight", {})

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            desc = "Highlight lsp references",
            group = au_lsp,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            desc = "Clear Highlight lsp references",
            group = au_lsp,
          })
        end
      end

    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = "LSP_Highlight",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- fixes the case where we do not create augroups when documentHighlight is not supported
      -- so we check if the client supports it before deleting the augroup to align with the logic in LspAttach
      if client then
        if client.supports_method("textDocument/documentHighlight") then
          vim.api.nvim_del_augroup_by_name("LSPDocumentHighlight")
        end
      end
    end,
  })

  -- cmp
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.toml",
    callback = function()
      require("cmp").setup.buffer({ sources = { { name = "crates" } } })
    end,
    group = au_cmp,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
      vim.wo.number = false
      vim.opt.statuscolumn = ""
    end,
    group = au_ft,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.org",
    callback = function()
      require("cmp").setup.buffer({ sources = { { name = "orgmode" } } })
    end,
    group = au_cmp,
  })
  -- util
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
      vim.highlight.on_yank()
    end,
    desc = "Highlight yank",
    group = au_utils,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
      vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
    end,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
          "i",
          false
        )
      end
    end,
  })
end

return M
