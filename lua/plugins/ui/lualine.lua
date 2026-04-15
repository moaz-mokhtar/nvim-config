local statusline = require("config.statusline")
local ai_mode = require("config.ai_mode")

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
      opts = opts or {}
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      -- Remove noisy Noice command/mode components (e.g. "<20>")
      opts.sections.lualine_x = vim.tbl_filter(function(component)
        if type(component) ~= "table" or type(component[1]) ~= "function" then
          return true
        end
        local info = debug.getinfo(component[1], "Sl")
        if not info or type(info.source) ~= "string" then
          return true
        end
        -- Drop LazyVim's Noice command/mode components.
        if info.source:find("/lazyvim/plugins/ui.lua", 1, true)
          and (info.linedefined == 116 or info.linedefined == 122)
        then
          return false
        end
        return true
      end, opts.sections.lualine_x)

      -- VSCode-like persistent AI provider label
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local mode = ai_mode.current_mode()
          if mode == ai_mode.modes.supermaven then
            return "SUPERMAVEN"
          elseif mode == ai_mode.modes.codeium then
            return "CODEIUM"
          elseif mode == "mixed" then
            return "MIXED"
          end
          return "OFF"
        end,
      })

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
