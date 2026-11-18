return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters = opts.linters or {}
    -- Use the copy that ships with this config (stdpath("config")) instead of a
    -- file in $HOME, so both machines lint against the same rule set.
    --
    -- `prepend_args`, not `args`: nvim-lint's default for this linter is
    -- `{ "-" }`, and that trailing `-` is what makes markdownlint-cli2 read the
    -- buffer from stdin. Replacing `args` outright makes it print its usage
    -- screen instead of linting.
    opts.linters["markdownlint-cli2"] = {
      prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.json" },
    }

    -- Registering the linter is not enough: LazyVim only runs linters that are
    -- listed in `linters_by_ft`, and its default table has no markdown entry.
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.markdown = { "markdownlint-cli2" }
    return opts
  end,
}
