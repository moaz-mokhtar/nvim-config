---@type LazySpec
-- NOTE: Ayu
return {
  "Shatur/neovim-ayu",
  main = "ayu",
  opts = {
    mirage = true,
    overrides = {
      DiffviewDiffDelete = { bg = "#422b2b", fg = "#422b2b" },
      LspReferenceRead = { link = "Underlined" },
      LspReferenceText = { link = "Underlined" },
      LspReferenceWrite = { link = "Underlined" },
      SnacksPickerDir = { fg = "#CCCAC2" },
    },
  },
  priority = 1000,
}
