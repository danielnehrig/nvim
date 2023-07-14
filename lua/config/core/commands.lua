local M = {}

M.init = function()
  vim.api.nvim_create_user_command("Transparency", function(_)
    require("config.themes").toggle_transparent()
  end, {})

  vim.api.nvim_create_user_command("Colorscheme", function(tbl)
    require("config.utils").switch_theme(tbl.args)
  end, {
    nargs = 1,
    complete = function(_, _, _)
      return require("config.utils").get_themes()
    end,
  })

  vim.api.nvim_create_user_command("StatuslineTheme", function(tbl)
    require("config.plugins.configs.statusline.windline").switch_theme(tbl.args)
  end, {
    nargs = 1,
    complete = function(_, _, _)
      return require("config.plugins.configs.statusline.windline").get_themes()
    end,
  })
end

return M
