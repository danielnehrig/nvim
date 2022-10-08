local config = {}

function config.dashboard()
  local _, db = pcall(require, "dashboard")
  db.preview_command = "cat | lolcat"
  db.preview_file_path = vim.fn.stdpath("config") .. "/neovim.cat"
  db.preview_file_height = 12
  db.preview_file_width = 80
  db.hide_tabline = true
  db.hide_statusline = true
end

return config
