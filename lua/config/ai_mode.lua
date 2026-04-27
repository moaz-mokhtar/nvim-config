local M = {}

M.modes = {
  off = "off",
  supermaven = "supermaven",
  codeium = "codeium",
}

local function load_plugin(name)
  pcall(vim.cmd, "silent! Lazy load " .. name)
end

local function supermaven_running()
  local ok, api = pcall(require, "supermaven-nvim.api")
  if not ok then
    return false
  end
  return api.is_running()
end

local function codeium_enabled()
  local ok, codeium = pcall(require, "codeium")
  if not ok or not codeium.s then
    return false
  end
  return codeium.s.enabled == true
end

local function set_supermaven(enable)
  if enable then
    load_plugin("supermaven-nvim")
  end

  local ok, api = pcall(require, "supermaven-nvim.api")
  if not ok then
    return false
  end

  if enable and not api.is_running() then
    api.start()
  elseif not enable and api.is_running() then
    api.stop()
  end

  return true
end

local function set_codeium(enable)
  if enable then
    load_plugin("codeium.nvim")
  end

  local ok, codeium = pcall(require, "codeium")
  if not ok or not codeium.s then
    return false
  end

  if enable and not codeium.s.enabled then
    codeium.enable()
  elseif not enable and codeium.s.enabled then
    codeium.disable()
  end

  return true
end

function M.current_mode()
  local sm_on = supermaven_running()
  local cd_on = codeium_enabled()

  if sm_on and not cd_on then
    return M.modes.supermaven
  end
  if cd_on and not sm_on then
    return M.modes.codeium
  end
  if not sm_on and not cd_on then
    return M.modes.off
  end
  return "mixed"
end

function M.apply(mode, opts)
  opts = opts or {}
  local notify = opts.notify ~= false

  if mode == M.modes.supermaven then
    set_codeium(false)
    set_supermaven(true)
  elseif mode == M.modes.codeium then
    set_supermaven(false)
    set_codeium(true)
  else
    mode = M.modes.off
    set_supermaven(false)
    set_codeium(false)
  end

  vim.g.ai_suggestion_mode = mode

  if notify then
    local label = (mode == M.modes.supermaven and "Supermaven")
      or (mode == M.modes.codeium and "Codeium")
      or "Off"
    vim.notify("Code suggestions: " .. label, vim.log.levels.INFO)
  end

  pcall(vim.cmd, "redrawstatus")
end

function M.cycle()
  local mode = M.current_mode()
  local next_mode = M.modes.off

  if mode == M.modes.off then
    next_mode = M.modes.supermaven
  elseif mode == M.modes.supermaven then
    next_mode = M.modes.codeium
  else
    next_mode = M.modes.off
  end

  M.apply(next_mode)
end

function M.statusline()
  local mode = M.current_mode()
  if mode == M.modes.supermaven then
    return " AI:SM "
  end
  if mode == M.modes.codeium then
    return " AI:CD "
  end
  if mode == "mixed" then
    return " AI:MIX "
  end
  return " AI:OFF "
end

function M.setup()
  vim.g.ai_suggestion_mode = M.modes.off

  local group = vim.api.nvim_create_augroup("ai_suggestion_default_mode", { clear = true })
  local enforce_default = function()
    vim.schedule(function()
      M.apply(vim.g.ai_suggestion_mode or M.modes.off, { notify = false })
    end)
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = enforce_default,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    once = true,
    callback = enforce_default,
  })
end

return M
