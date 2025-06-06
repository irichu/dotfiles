return {
  {
    "sainnhe/sonokai",
    priority = 1,
    config = function()
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_enable_italic = "1"
      vim.g.sonokai_better_performance = "1"
      vim.g.sonokai_menu_selection_background = "green"
      -- vim.g.sonokai_style = "maia"
      vim.g.sonokai_style = "andromeda"
      vim.cmd.colorscheme("sonokai")
    end,
  },
}
