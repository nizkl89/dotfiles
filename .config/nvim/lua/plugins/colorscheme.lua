return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "moon",
      on_highlights = function(hl, c)
        -- Override LineNrAbove and LineNrBelow to use a much less bright, clearly visible off-white
        hl.LineNrAbove = {
          fg = "#A8A8A8", -- Darker off-white, much less bright than #C0C0C0, not grey
        }
        hl.LineNrBelow = {
          fg = "#A8A8A8", -- Darker off-white, much less bright than #C0C0C0
        }
        hl.LineNr = {
          fg = c.blue, -- Keep current line number as blue for contrast
        }
      end,
    },
  },
}
