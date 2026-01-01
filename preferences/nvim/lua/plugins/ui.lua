return {
  -- Bufferline: always show buffer tab
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  -- Onedark theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- dark, darker, cool, deep, warm, warmer
      })
      require("onedark").load()
    end,
  },
}
