local M = {}
M.init = function()
  vim.api.nvim_create_user_command("PackerSync2", function(_)
    require("config.packer-config.funcs").packer_sync()
  end, {})
end

return M
