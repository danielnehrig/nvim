local M = {}

function M.init()
  require("github-notifications").setup({
    username = os.getenv("GH_REGISTRY_USERNAME"),
    token = os.getenv("GH_TOKEN"),
  })
end

function M.load()
  if not packer_plugins["github-notifications.nvim"].loaded then
    vim.cmd([[ packadd github-notifications.nvim ]])
  end
end

return M
