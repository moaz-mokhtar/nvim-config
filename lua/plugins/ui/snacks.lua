---@type LazySpec
-- NOTE: QoL Plugins
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      sources = {
        keymaps = {
          format = function(item, picker)
            local ret = {}
            local k = item.item
            local a = Snacks.picker.util.align

            -- Col 1: Icon
            if package.loaded["which-key"] then
              local Icons = require("which-key.icons")
              local icon, hl = Icons.get({ keymap = k, desc = k.desc })
              ret[#ret + 1] = icon and { a(icon, 3), hl } or { "   " }
            end

            -- Col 2: Mode
            ret[#ret + 1] = { k.mode, "SnacksPickerKeymapMode" }
            ret[#ret + 1] = { " " }

            -- Col 3: LHS
            local lhs = Snacks.util.normkey(k.lhs)
            ret[#ret + 1] = { a(lhs, 15), "SnacksPickerKeymapLhs" }
            ret[#ret + 1] = { " " }

            -- Col 4: Nowait
            local icon_nowait = picker.opts.icons.keymaps.nowait
            if k.nowait == 1 then
              ret[#ret + 1] = { icon_nowait, "SnacksPickerKeymapNowait" }
            else
              ret[#ret + 1] = { (" "):rep(vim.api.nvim_strwidth(icon_nowait)) }
            end
            ret[#ret + 1] = { " " }

            -- Col 5: Desc (was col 7, shifted 2 left)
            ret[#ret + 1] = { a(k.desc or "", 20) }
            ret[#ret + 1] = { " " }

            -- Col 6: Buffer
            if k.buffer and k.buffer > 0 then
              ret[#ret + 1] = { a("buf:" .. k.buffer, 6), "SnacksPickerBufNr" }
            else
              ret[#ret + 1] = { a("", 6) }
            end
            ret[#ret + 1] = { " " }

            -- Col 7: RHS
            local rhs_len = 0
            if k.rhs and k.rhs ~= "" then
              local rhs = k.rhs
              rhs_len = #rhs
              if rhs:lower():find("^<plug>") then
                ret[#ret + 1] = { "<Plug>", "NonText" }
                local plug = rhs:sub(7):gsub("^%(", ""):gsub("%)$", "")
                ret[#ret + 1] = { "(", "SnacksPickerDelim" }
                Snacks.picker.highlight.format(item, plug, ret, { lang = "vim" })
                ret[#ret + 1] = { ")", "SnacksPickerDelim" }
              else
                ret[#ret + 1] = { k.rhs, "SnacksPickerKeymapRhs" }
              end
            else
              ret[#ret + 1] = { "callback", "Function" }
              rhs_len = 8
            end
            if rhs_len < 15 then
              ret[#ret + 1] = { (" "):rep(15 - rhs_len) }
            end

            if item.file then
              ret[#ret + 1] = { " " }
              vim.list_extend(ret, require("snacks.picker.format").filename(item, picker))
            end
            return ret
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
  },
}
