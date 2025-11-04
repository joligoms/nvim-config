require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {
  desc = "cd to passed $PWD when vim starts.",
  group = vim.api.nvim_create_augroup("cd-to-pwd", { clear = true }),
  callback = function()
    local args = vim.fn.argv()

    if #args > 0 then
      local arg = vim.fn.expand(args[1])
      local target_dir

      if vim.fn.isdirectory(arg) == 1 then
        target_dir = arg
      else
        target_dir = vim.fn.fnamemodify(arg, ":h")
      end

      -- vim.notify("Arg: " .. arg, vim.log.levels.INFO)
      -- vim.notify("Target dir: " .. target_dir, vim.log.levels.INFO)
      -- vim.notify("Before: " .. vim.fn.getcwd(), vim.log.levels.INFO)

      vim.api.nvim_set_current_dir(target_dir)

      -- vim.notify("After: " .. vim.fn.getcwd(), vim.log.levels.INFO)
    end
  end,
})

autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
  end,
})
