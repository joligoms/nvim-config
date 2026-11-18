-- Use the Roslyn language server for C# instead of OmniSharp.
-- Neovim 0.12+ (Fedora 44) -> roslyn.nvim main works, no commit pin needed.
return {
  -- 1) Turn off OmniSharp (it comes from the lang.dotnet extra)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = { enabled = false },
      },
    },
  },

  -- 2) Teach Mason about the roslyn package and auto-install it
  --
  -- `opts` must be a function: lazy *replaces* list values (it does not merge
  -- them) when several files configure the same plugin, and the order in which
  -- lua/plugins/*.lua load follows directory order, not alphabetical order. A
  -- plain `ensure_installed = { "roslyn" }` here would therefore wipe the tool
  -- list that core.lua installs, non-deterministically across machines.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Roslyn lives in a third-party registry and needs the .NET SDK, so on a
      -- machine without dotnet adding it would just make Mason fail every start.
      if vim.fn.executable("dotnet") ~= 1 then
        return
      end

      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      if not vim.tbl_contains(opts.registries, "github:Crashdummyy/mason-registry") then
        table.insert(opts.registries, "github:Crashdummyy/mason-registry") -- provides `roslyn`
      end

      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "roslyn") then
        table.insert(opts.ensure_installed, "roslyn")
      end
    end,
  },

  -- 3) The Roslyn LSP plugin
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "vb" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- defaults are fine; see :h roslyn
    },
  },

  -- 4) DAP: auto-descobrir o projeto, compilar e resolver o .dll
  --    (deixa de pedir "Path to dll:" e recompila antes de cada debug)
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      local function build_and_find_dll()
        -- encontra o .csproj subindo a partir do ficheiro atual
        local csproj = vim.fs.find(function(name)
          return name:match("%.csproj$")
        end, { upward = true, path = vim.fn.expand("%:p:h") })[1]

        if not csproj then
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
        end

        local proj_dir = vim.fs.dirname(csproj)
        local proj_name = vim.fn.fnamemodify(csproj, ":t:r")

        -- compila em Debug (necessário para os breakpoints ligarem)
        vim.notify("dotnet build " .. proj_name .. "…", vim.log.levels.INFO)
        local out = vim.fn.system({ "dotnet", "build", proj_dir, "-c", "Debug" })
        if vim.v.shell_error ~= 0 then
          vim.notify(out, vim.log.levels.ERROR, { title = "dotnet build falhou" })
          return dap.ABORT -- cancela o arranque do debug
        end

        -- resolve o .dll em bin/Debug/<tfm>/
        local hits = vim.fn.glob(proj_dir .. "/bin/Debug/*/" .. proj_name .. ".dll", false, true)
        if #hits == 0 then
          return vim.fn.input("Path to dll: ", proj_dir .. "/bin/Debug/", "file")
        end
        return hits[1]
      end

      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        dap.configurations[lang] = {
          {
            type = "netcoredbg",
            name = "Launch (auto build)",
            request = "launch",
            program = build_and_find_dll,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
