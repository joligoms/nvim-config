require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  html = {},
  cssls = {},
  ts_ls = {},
  tailwindcss = {},
  ["copilot-language-server"] = { enabled = false },
  ["copilot_lsp"] = {},
  markdown = {},
  markdown_inline = {},
}

local on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  -- Custom LSP keymaps
  -- vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = bufnr })

  if client.name == "ts_ls" then
    vim.keymap.set("n", "<leader>li", function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      }
    end, { buffer = bufnr, desc = "Organize Imports" })
  end

  if client.name == "ts_ls" then
    vim.keymap.set("n", "<leader>li", function()
      client:exec_cmd({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, { buffer = bufnr, desc = "Organize Imports" })
  end
end

for name, opts in pairs(servers) do
  opts.on_attach = on_attach
  opts.on_init = nvlsp.on_init
  opts.capabilities = nvlsp.capabilities

  vim.lsp.config(name, (opts.cfg or {}))
  vim.lsp.enable(name, (opts.enabled or true))
end

-- read :h vim.lsp.config for changing options of lsp servers
