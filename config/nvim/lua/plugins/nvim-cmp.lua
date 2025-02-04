return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm()
              -- local entry = cmp.get_selected_entry()
              -- if not entry then
              --   cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              -- else
              --   cmp.confirm()
              -- end
            else
              fallback()
            end
          end, { "i", "s", "c" }),
        },
      })
    end,
  },
}
