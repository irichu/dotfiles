return {
  {
    "saghen/blink.cmp",
    ---@class PluginLspOpts
    opts = {
      signature = { enabled = true },
      keymap = {
        -- preset = "super-tab",
        -- preset = "none",
        preset = "default",
        ["<CR>"] = { "cancel", "fallback" },
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "cancel", "fallback" },

        ["<F1>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<C-e>"] = { "hide" },
        -- ["<C-y>"] = { "select_and_accept" },

        -- ["<Up>"] = { "select_prev", "fallback" },
        -- ["<Down>"] = { "select_next", "fallback" },
        -- ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        -- ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        --
        -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
    },
  },
}
