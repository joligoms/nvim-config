-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
map({ "i" }, "jk", "<ESC>")

-- Terminal mappings
map("t", "<C-x>", [[<C-\><C-n>"]], { desc = "Terminal -> Normal" })
map({ "n", "t" }, "<M-h>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Horizontal Terminal" })
