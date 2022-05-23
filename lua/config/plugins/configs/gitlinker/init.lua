local M = {}

function M.init()
  local add, _ = pcall(vim.cmd, "packadd gitlinker.nvim")
  if not add then
    return
  end
  local present, gitlinker = pcall(require, "gitlinker")
  if not present then
    return
  end

  gitlinker.setup({
    opts = {
      remote = nil, -- force the use of a specific remote
      -- adds current line nr in the url for normal mode
      add_current_line_on_normal_mode = true,
      -- callback for what to do with the url
      action_callback = require("gitlinker.actions").copy_to_clipboard,
      -- print the url after performing the action
      print_url = true,
      -- mapping to call url generation
      mappings = "<space>gy",
    },
    callbacks = {
      ["github.com"] = require("gitlinker.hosts").get_github_type_url,
      ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
    },
  })
end

function M.normal()
  local present, gitlinker = pcall(require, "gitlinker")
  if not present then
    M.init()
  end
  gitlinker.get_buf_range_url(
    "n",
    { action_callback = require("gitlinker.actions").open_in_browser }
  )
end

function M.visual()
  local present, gitlinker = pcall(require, "gitlinker")
  if not present then
    M.init()
  end
  gitlinker.get_buf_range_url(
    "v",
    { action_callback = require("gitlinker.actions").open_in_browser }
  )
end

return M
