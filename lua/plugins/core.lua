return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "ellisonleao/dotenv.nvim",
    opts = {
      enable_on_load = true,
      verbose = true,
      file_name = vim.fn.stdpath("config") .. "/.env",
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "phpactor",
        "phpcs",
        "php-cs-fixer",
        "css-lsp",
      },
    },
  },
}
