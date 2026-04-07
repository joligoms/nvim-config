local function git_repo_name()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")

  if not handle then
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  if result == "" then
    return nil
  end

  local repo_path = vim.trim(result)
  return vim.fn.fnamemodify(repo_path, ":t")
end

return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
█▄ █ ██▀ ▄▀▄ █ █ █ █▄ ▄█
█ ▀█ █▄▄ ▀▄▀ ▀▄▀ █ █ ▀ █
          ]],
        },
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            layout = { layout = { position = "right" } },
          },
          files = {
            hidden = true,
            follow = false,
          },
          git_files = {
            untracked = true,
          },
          projects = {
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
          },
        },
      },
    },
  },
  {
    "voldikss/vim-floaterm",
    cmd = { "FloatermNew", "FloatermToggle", "FloatermNext", "FloatermPrev" },
    config = function()
      vim.g.floaterm_title = "Terminal: $1/$2"
    end,
    keys = {
      { "<M-i>", "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm", mode = { "n", "i", "t" } },
      { "<M-I>", "<cmd>FloatermNew<cr>", desc = "New Floaterm", mode = { "n", "i", "t" } },
      { "<M-{>", "<cmd>FloatermPrev<cr>", desc = "Previous Floaterm", mode = { "n", "t" } },
      { "<M-}>", "<cmd>FloatermNext<cr>", desc = "Next Floaterm", mode = { "n", "t" } },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_b = {
        {
          function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          icon = " ",
        },
        "branch",
      }
      return opts
    end,
  },
}
