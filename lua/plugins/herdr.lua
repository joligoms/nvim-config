return {
  -- Annotation workflow for the herdr-nvim plugin.
  -- Pairs with the herdr-side plugin installed via `herdr plugin install ChmaraX/herdr-nvim`.
  -- Prefix is <leader>a ("annotate"): free now that CodeCompanion is gone, and
  -- better than <leader>H because <leader>h is the htop CLI and shift-chords are
  -- easy to mistype.
  -- Keymaps: <leader>ac comment, <leader>al list, <leader>as send,
  --          <leader>aS submit, <leader>ai ref. See :help herdr-nvim.
  -- `cond`: herdr is only installed on the work machine; elsewhere the plugin
  -- would load and fail on every keypress.
  {
    "ChmaraX/herdr-nvim",
    cond = vim.fn.executable("herdr") == 1,
    opts = { prefix = "<leader>a" },
  },
}
