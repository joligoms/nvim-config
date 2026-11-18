return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "", -- "hard" | "soft" | "" (medium)
      transparent_mode = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      float = {
        transparent = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    transparent = true,
    opts = {
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
