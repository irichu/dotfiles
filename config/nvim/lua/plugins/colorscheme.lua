return {
  "sainnhe/sonokai",
  lazy = true,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.sonokai_enable_italic = "1"
    vim.g.sonokai_transparent_background = "1"
    vim.g.sonokai_better_performance = "1"
    vim.g.sonokai_menu_selection_background = "green"
    vim.g.sonokai_style = "andromeda"
    vim.cmd.colorscheme("sonokai")
  end,
}

