local utils = require("color-board.utils")
local M = {}

---@class color-board.ctx
---@field buf integer       The buffer used by color-board
---@field baleia Baleia     The Baleia instance
---@field namespace integer The ID of the highlight group
---
---@field valid string[]  An array of valid dashboard names
---@field current string  The name of the currently active dashboard
---
---@field pos integer           The current position in the keymaps
---@field key_render string[]   The rendered keymaps
---@field keys_row integer      The top-left row position of the keymap render
---@field keys_column integer   The top-left column position of the keymap render
---
---@filed opts color-board.config The config
---
local ctx = {
  buf = 0,
  baleia = require("baleia").setup(),
  namespace = 0,

  valid = {},
  current = "",

  keys_render = {},
  pos = 0,
  keys_row = 0,
  keys_column = 0,
}

local function render()
  local db = ctx.opts.dashboards[ctx.current]
  local tb = {}

  local top_margin = math.floor((vim.o.lines - db.height - #ctx.keys_render) / ctx.opts.proportion)
  local left_margin = string.rep(" ", math.floor((vim.o.columns - db.width) / 2))

  for i = 1, top_margin do tb[i] = "" end

  if db.ascii then
    for i = 1, #db.ascii do
      tb[#tb + 1] = left_margin .. db.ascii[i]
    end
  else
    for _, line in ipairs(vim.fn.readfile(db.path)) do
      tb[#tb + 1] = left_margin .. line
    end
  end

  left_margin = string.rep(" ", math.floor((vim.o.columns - ctx.opts.keymap_width) / 2))

  ctx.keys_row = #tb + ctx.opts.space + 1
  ctx.keys_column = #left_margin

  for _, line in ipairs(ctx.keys_render) do
    tb[#tb + 1] = left_margin .. line
  end

  if db.colored then
    ctx.baleia.buf_set_lines(ctx.buf, 0, -1, true, tb)
  else
    vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, true, tb)
    vim.api.nvim_buf_set_extmark(ctx.buf, ctx.namespace, top_margin, 0, {
      end_row = top_margin + db.height,
      hl_group = "DashboardHeader",
    })
  end

  vim.api.nvim_win_set_cursor(0, { ctx.keys_row + ctx.pos, ctx.keys_column })
end

local function resize()
  if not utils.is_valid(ctx) then
    local valid = {}

    for _, name in ipairs(ctx.valid) do
      if utils.is_valid(ctx) then
        table.insert(valid, name)
      end
    end

    if #valid == 0 then return end
    ctx.valid = valid
    ctx.current = ctx.valid[math.random(#ctx.valid)]
  end

  render()
end

function M.instantiate()
  if not ctx.opts or not ctx.opts.dashboards then error("no setup") end
  if not next(ctx.opts.dashboards) then return end

  if not ctx.buf or not vim.api.nvim_buf_is_valid(ctx.buf) then
    ctx.buf = vim.api.nvim_create_buf(false, false)
  end

  for name, db in pairs(ctx.opts.dashboards) do
    if utils.is_valid(ctx, db) then
      table.insert(ctx.valid, name)
    end
  end

  if #ctx.valid == 0 then return end

  ctx.current = ctx.valid[math.random(#ctx.valid)]
  render()

  vim.opt_local.modifiable = false
  vim.opt_local.modified = false
  vim.opt_local.number = false
  vim.opt_local.fillchars = "eob: "

  vim.api.nvim_create_autocmd("VimResized", { buffer = ctx.buf, callback = resize })

  utils.register_keymap(ctx)
end

---@param opts color-board.config
function M.setup(opts)
  opts = opts or {}

  ctx.opts = vim.tbl_deep_extend("force", require("color-board.config").default_opts(), opts)
  ctx.namespace = vim.api.nvim_create_namespace("color-board")
  ctx.keys_render = utils.render_keymaps(ctx)
end

return M
