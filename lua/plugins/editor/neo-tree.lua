---@type LazySpec
-- NOTE: File Tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    add_blank_line_at_top = false,
    source_selector = {
      winbar = true,
    },
    hide_root_node = true,
    retain_hidden_root_indent = true,
  },
}
