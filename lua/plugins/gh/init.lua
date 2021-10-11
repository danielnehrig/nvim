local M = {}

function M.init()
  local username = os.getenv("GH_REGISTRY_USERNAME")
  local token = os.getenv("GH_TOKEN")
  local username_len = string.len(username)
  local token_len = string.len(token)

  if username_len > 1 and token_len > 1 then
    require("github-notifications").setup({
      username = username,
      token = token,
    })
  end
end

function M.load()
  if not packer_plugins["github-notifications.nvim"].loaded then
    vim.cmd([[ packadd github-notifications.nvim ]])
  end
end

return M
