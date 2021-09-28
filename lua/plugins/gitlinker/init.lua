local cmd = vim.cmd
local gitlinker = nil
local M = {}

function M.init()
  if not packer_plugins["plenary.nvim"].loaded then
    cmd([[packadd plenary.nvim]])
  end

  if not packer_plugins["gitlinker.nvim"].loaded then
    cmd([[packadd gitlinker.nvim]])
    gitlinker = require("gitlinker")
  end

  if not packer_plugins["gitlinker.nvim"].loaded then
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

function M:normal()
  self.init()
  gitlinker.get_buf_range_url("n")
end

function M:visual()
  self.init()
  gitlinker.get_buf_range_url("v")
end

return M
