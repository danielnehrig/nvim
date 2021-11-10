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
      description = {
        "Next Checkout                       https://github.com/redteclab/next-checkout",
      },
      command = "cd ~/code/work/next-checkout",
    },
    repo2 = {
      description = {
        "Fock                                https://github.com/redteclab/fock",
      },
      command = "cd ~/code/work/fock",
    },
    repo3 = {
      description = {
        "Bully                               https://github.com/redteclab/bully",
      },
      command = "cd ~/code/work/bully",
    },
    repo4 = {
      description = {
        "Api                                 https://github.com/redteclab/api",
      },
      command = "cd ~/code/work/api",
    },
  }
end

return config
