return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "gemini",
      providers = {
        gemini = {
          api_key_name = "GEMINI_API_KEY",
          model = "gemini-2.5-flash",
          timeout = 30000,
          extra_request_body = {
            generationConfig = {
              temperature = 0.7,
            },
          },
        },
      },
    },
  },
}
