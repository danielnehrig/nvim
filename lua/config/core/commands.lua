local M = {}
M.init = function()
  vim.api.nvim_create_user_command("PackerSync2", function(_)
    require("config.packer-config.funcs").packer_sync()
  end, {})

  vim.api.nvim_create_user_command("Colorscheme", function(tbl)
    require("config.packer-config.funcs").switch_theme(tbl.args)
  end, {
    nargs = 1,
    complete = function(_, _, _)
      return require("config.packer-config.funcs").get_themes()
    end,
  })

  vim.api.nvim_create_user_command("StatuslineTheme", function(tbl)
    require("config.plugins.statusline.windline").switch_theme(tbl.args)
  end, {
    nargs = 1,
    complete = function(_, _, _)
      return require("config.plugins.statusline.windline").get_themes()
    end,
  })
end

return M
