local g = vim.g
local M = {}

function M.init()
  g.nvim_tree_side = "left"
  g.nvim_tree_width = 25
  g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
  g.nvim_tree_quit_on_open = 0
  g.nvim_tree_indent_markers = 1
  g.nvim_tree_hide_dotfiles = 1
  g.nvim_tree_git_hl = 1
  g.nvim_tree_root_folder_modifier = ":~"
  g.nvim_tree_allow_resize = 1

  g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
  }

  g.nvim_tree_icons = {
    default = " ",
    symlink = " ",
    git = {
      unstaged = "✗",
      staged = "✓",
      unmerged = "",
      renamed = "➜",
      untracked = "★",
    },
    folder = {
      default = "",
      open = "",
      symlink = "",
    },
  }
end

return M
