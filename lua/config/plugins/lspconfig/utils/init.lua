local M = {}

function M.rename()
  vim.cmd([[ packadd playground ]])
  local rename = "textDocument/rename"
  local currName = vim.fn.expand("<cword>")
  local tshl = require("nvim-treesitter-playground.hl-info").get_treesitter_hl()
  if tshl and #tshl > 0 then
    local ind = tshl[#tshl]:match("^.*()%*%*.*%*%*")
    tshl = tshl[#tshl]:sub(ind + 2, -3)
  end

  local win = require("plenary.popup").create(currName, {
    title = "New Name",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "FloatBorder",
    titlehighlight = "Title",
    highlight = tshl,
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  local map_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(
    0,
    "i",
    "<Esc>",
    "<cmd>stopinsert | q!<CR>",
    map_opts
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<Esc>",
    "<cmd>stopinsert | q!<CR>",
    map_opts
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "i",
    "<CR>",
    "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>",
    map_opts
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<CR>",
    "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>",
    map_opts
  )

  local function handler(err, result, ctx, config)
    if err then
      vim.notify(
        ("Error running lsp query '%s': %s"):format(rename, err),
        vim.log.levels.ERROR
      )
    end
    local new
    if result and result.changes then
      local msg = ""
      for f, c in pairs(result.changes) do
        new = c[1].newText
        msg = msg
          .. ("%d changes -> %s"):format(
            #c,
            f:gsub("file://", ""):gsub(vim.fn.getcwd(), ".")
          )
          .. "\n"
        msg = msg:sub(1, #msg - 1)
        vim.notify(
          msg,
          vim.log.levels.INFO,
          { title = ("Rename: %s -> %s"):format(currName, new) }
        )
      end
    end
    vim.lsp.handlers[rename](err, result, ctx, config)
  end

  function _G._rename(curr)
    local newName = vim.trim(vim.fn.getline("."))
    vim.api.nvim_win_close(win, true)
    if #newName > 0 and newName ~= curr then
      local params = vim.lsp.util.make_position_params()
      params.newName = newName
      vim.lsp.buf_request(0, rename, params, handler)
    end
  end
end

return M
