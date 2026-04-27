return {
  "stevearc/aerial.nvim",
  opts = function(_, opts)
    opts.backends = {
      rust = { "treesitter", "lsp" },
      _ = { "lsp", "treesitter", "markdown", "man" },
    }
  end,
}
