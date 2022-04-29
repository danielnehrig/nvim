local M = {}

function M.map(bufnr, type, key, value, opt)
  if opt then
    vim.api.nvim_buf_set_keymap(bufnr, type, key, value, opt)
  else
    vim.api.nvim_buf_set_keymap(
      bufnr,
      type,
      key,
      value,
      { noremap = true, silent = true, expr = false }
    )
  end
end

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
    return
  else
    vim.cmd("copen")
    return
  end
end

function M.open_diag_float()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  vim.diagnostic.open_float({
    focusable = false,
    focus = false,
    border = "single",
  })
end

function M.map_global(type, key, value, expr)
  vim.api.nvim_set_keymap(
    type,
    key,
    value,
    { noremap = true, silent = true, expr = expr }
  )
end

--- Replaces / or \\ depending on os to path to correct places
--- @param str string
--- @return string
function M.sep_os_replacer(str)
  local result = str
  local path_sep = package.config:sub(1, 1)
  result = result:gsub("/", path_sep)
  return result
end

return M
