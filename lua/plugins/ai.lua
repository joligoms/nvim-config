return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    opts = {
      strategies = {
        chat = {
          name = "copilot",
          model = "claude-sonnet-4-5-20250929",
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
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
    },
  },
}
