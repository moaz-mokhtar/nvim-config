---@type LazySpec
return {
  {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = {},
    config = function(_, opts)
      require("dropbar").setup(opts)
    end,
    keys = {
      {
        "<leader>cbp",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Dropbar (breadcrumb) | Pick",
      },
      {
        "<leader>cbs",
        function()
          require("dropbar.api").goto_context_start()
        end,
        desc = "Dropbar | Go to context start",
      },
      {
        "<leader>cbn",
        function()
          require("dropbar.api").select_next_context()
        end,
        desc = "Dropbar | Next context",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>cb", group = "Dropbar" },
      },
    },
  },
}
