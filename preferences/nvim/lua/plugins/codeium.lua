return {
  -- Codeium: inline AI code suggestions (ghost text)
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      vim.g.codeium_disable_bindings = 1
      -- Tab to accept suggestion
      vim.keymap.set("i", "<Tab>", function()
        if vim.fn["codeium#Accept"]() ~= "" then
          return vim.fn["codeium#Accept"]()
        else
          return "<Tab>"
        end
      end, { expr = true, silent = true })
      -- Ctrl+] to next suggestion
      vim.keymap.set("i", "<C-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      -- Ctrl+[ to previous suggestion
      vim.keymap.set("i", "<C-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      -- Ctrl+x to clear
      vim.keymap.set("i", "<C-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
}
