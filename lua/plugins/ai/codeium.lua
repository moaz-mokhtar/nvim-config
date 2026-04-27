---@type LazySpec
-- NOTE: Codeium
return {
  {
    "Exafunction/codeium.nvim",
    opts = function(_, opts)
      opts.virtual_text = opts.virtual_text or {}
      opts.virtual_text.filetypes = opts.virtual_text.filetypes or {}
      opts.virtual_text.filetypes.snacks_picker_input = false
    end,
  },
}
