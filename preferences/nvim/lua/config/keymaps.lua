-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+e: Neo-tree focus/toggle
vim.keymap.set("n", "<C-e>", "<cmd>Neotree focus<cr>", { desc = "Focus Neo-tree" })

-- Option+h/l: Buffer navigation
vim.keymap.set("n", "<A-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
