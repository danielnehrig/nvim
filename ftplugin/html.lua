--  vim.api.nvim_create_autocmd("FileType", {
--  pattern = "*.html",
--  callback = function()
--  vim.bo.filetype = "html"
--  end,
--  })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.html",
  callback = function()
    vim.bo.filetype = "html"
  end,
})
