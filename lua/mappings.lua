require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope

local function grep_with_telescope()
  local mode = vim.fn.mode()
  local text = ""
  if mode == "v" or mode == "V" or mode == "\22" then -- visual, visual-line, visual-block
    vim.cmd('normal! "zy')
    text = vim.fn.getreg("z")
  else
    text = vim.fn.expand("<cWORD>")
  end
  text = text:gsub(" ", "\\ ")
  vim.cmd("Telescope grep_string default_text=" .. text)
end

map({ "n", "v" }, "<leader>fw", grep_with_telescope, { desc = "grep word/selection with Telescope", silent = true })

local function live_grep_with_telescope()
  local mode = vim.fn.mode()
  local text = ""
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.cmd('normal! "zy')
    text = vim.fn.getreg("z")
  else
    text = ""
  end
  text = text:gsub(" ", "\\ ")
  if text ~= "" then
    vim.cmd("Telescope live_grep default_text=" .. text)
  else
    vim.cmd("Telescope live_grep")
  end
end

map({ "n", "v" }, "<leader>fg", live_grep_with_telescope, { desc = "live grep with Telescope", silent = true })
