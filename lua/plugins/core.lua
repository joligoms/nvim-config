return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox")
      end,
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
    opts = { ensure_installed = { "prettier" } },
  },

  {
    "natecraddock/workspaces.nvim",
    cmd = { "WorkspacesAdd", "WorkspacesOpen", "WorkspacesRemove", "WorkspacesList" },
    opts = {
      cd_type = "global",
      sort = true,
      mru_sort = true,
      notify_info = true,
      hooks = {
        open = function()
          Snacks.picker.files()
        end,
      },
    },
    keys = {
      {
        "<leader>fw",
        function()
          local ws = require("workspaces")
          local list = ws.get()
          if vim.tbl_isempty(list) then
            vim.notify("Sem workspaces. Usa :WorkspacesAdd <nome> <path>", vim.log.levels.WARN)
            return
          end
          local items = {}
          for _, w in ipairs(list) do
            table.insert(items, { text = w.name .. "  " .. w.path, name = w.name, path = w.path })
          end
          Snacks.picker.pick({
            title = "Workspaces",
            items = items,
            format = "text",
            confirm = function(picker, item)
              picker:close()
              if item then ws.open(item.name) end
            end,
          })
        end,
        desc = "Open Workspace",
      },
    },
  },
}
