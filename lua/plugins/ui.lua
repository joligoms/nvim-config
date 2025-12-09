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
}
