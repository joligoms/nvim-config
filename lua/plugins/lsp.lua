return {
  {
    {
      "neovim/nvim-lspconfig",
      opts = {
        ---@type table<string, vim.lsp.Config>
        servers = {
          settings = {
            eslint = {
              workingDirectories = { mode = "auto" },
              format = AUTO_FORMAT,
            },
          },
        },
        setup = {
          eslint = function()
            if not AUTO_FORMAT then
              return
            end

            local formatter = LazyVim.lsp.formatter({
              name = "eslint: lsp",
              primary = false,
              priority = 200,
              filter = "eslint",
            })

            LazyVim.format.register(formatter)

            -- Snacks.util.lsp.on(function(_, client)
            --   if client.name == "eslint" then
            --     client.server_capabilities.documentFormattingProvider = true
            --   elseif client.name == "tsserver" then
            --     client.server_capabilities.documentFormattingProvider = false
            --   end
            -- end)
          end,
        },
      },
    },
  },
}
