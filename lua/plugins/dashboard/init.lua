local config = {}

function config.dashboard()
  vim.g.dashboard_footer_icon = "ﬦ "
  vim.g.dashboard_preview_command = "cat"
  vim.g.dashboard_preview_pipeline = "lolcat"
  vim.g.dashboard_preview_file = vim.fn.stdpath("config") .. "/neovim.cat"
  vim.g.dashboard_preview_file_height = 12
  vim.g.dashboard_preview_file_width = 80
  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_custom_section = {
    repo1 = {
      description = { "Next Checkout" },
      command = "cd ~/code/work/next-checkout",
    },
    repo2 = {
      description = { "Fock" },
      command = "cd ~/code/work/fock",
    },
    repo3 = {
      description = { "Bully" },
      command = "cd ~/code/work/bully",
    },
    repo4 = {
      description = { "Api" },
      command = "cd ~/code/work/api",
    },
  }
end

return config
