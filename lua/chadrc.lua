-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

vim.cmd "highlight St_relativepath guifg=#626a83 guibg=#2a2b36"

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "cd to passed $PWD when vim starts.",
  group = vim.api.nvim_create_augroup("cd-to-pwd", { clear = true }),
  callback = function()
    local pwd = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(pwd)
  end,
})

M.base46 = {
  theme = "wombat",
  transparency = true,

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.cheatsheet = {
  theme = "simple",
}

M.mason = {
  pkgs = {
    "eslint-lsp",
    "prettierd",
    "tailwindcss-language-server",
    "typescript-language-server",
  },
}

M.ui = {
  statusline = {
    theme = "default",
    order = { "mode", "relativepath", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      relativepath = function()
        local path = vim.api.nvim_buf_get_name(stbufnr())

        if path == "" then
          return ""
        end

        return "%#St_relativepath#  " .. vim.fn.expand "%:.:h" .. " /"
      end,
    },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = { ":(){ :|:& };: <CR>" },
}

M.lsp = {
  signature = true,
}

-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
