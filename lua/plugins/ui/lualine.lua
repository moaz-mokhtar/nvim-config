local statusline = require("config.statusline")

---@type LazySpec
-- NOTE: Statusline
return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = vim.g.colorscheme ~= "nvchad",
    init = function()
      if vim.g.statusline_time == nil then
        vim.g.statusline_time = false
      end

      if vim.fn.exists(":StatuslineTimeToggle") == 0 then
        vim.api.nvim_create_user_command("StatuslineTimeToggle", function()
          vim.g.statusline_time = not vim.g.statusline_time
          local ok, lualine = pcall(require, "lualine")
          if ok then
            lualine.refresh({ place = { "statusline" } })
          end
          vim.cmd.redrawstatus()
        end, { desc = "Toggle time in statusline" })
      end

      vim.keymap.set("n", "<leader>uo", "<cmd>StatuslineTimeToggle<cr>", {
        desc = "Toggle Statusline Time",
        silent = true,
      })
    end,
    opts = function(_, opts)
      -- table.insert(opts.sections.lualine_x, { statusline.clients })
      table.insert(opts.sections.lualine_x, {
        function()
          local venv = statusline.python_venv()
          return venv ~= " " and venv or ""
        end,
      })
      opts.sections.lualine_z = {
        {
          function()
            return " " .. os.date("%R")
          end,
          cond = function()
            return vim.g.statusline_time == true
          end,
        },
      }
      opts.always_show_tabline = false
    end,
  },
}
