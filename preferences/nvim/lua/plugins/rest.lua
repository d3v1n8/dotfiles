return {
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    ft = "http",
    keys = {
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Run request" },
      { "<leader>rl", "<cmd>Rest last<cr>", desc = "Re-run last request" },
      { "<leader>re", "<cmd>Telescope rest select_env<cr>", desc = "Select environment" },
    },
    config = function()
      require("telescope").load_extension("rest")
    end,
  },
}
