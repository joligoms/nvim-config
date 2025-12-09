return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-5-mini",
          },
        },
        inline = {
          adapter = "copilot",
        },
      },
      memory = {
        default = {
          description = "Collection of common files for all projects",
          files = {
            ".clinerules",
            ".cursorrules",
            ".rules",
            ".copilot-instructions.md",
            ".github/copilot-instructions.md",
            "AGENT.md",
            "AGENTS.md",
            "CLAUDE.md",
            ".claude",
          },
        },
        opts = {
          chat = {
            default_memory = { "default" },
          },
        },
      },
    },
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion New Chat" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
    },
  },

  -- For pasting images from clipboard
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
