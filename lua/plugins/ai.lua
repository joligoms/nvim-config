return {
  {
    "olimorris/codecompanion.nvim",
    version = "v19.3.0",
    opts = {
      adapters = {
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "CLAUDE_CODE_OAUTH_TOKEN",
              },
            })
          end,
        },
      },
      interactions = {
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
      extensions = {
        history = {
          enabled = true,
          opts = {
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_chats.json",
            title_generation_opts = {
              adapter = "copilot",
              model = "gpt-5-mini",
            },
          },
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
      display = {
        chat = { window = { position = "left", width = 0.3 } },
      },
    },
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    keys = {
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion New Chat" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "pnpm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
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
