local M = {}

--- Deregister default movement keys and register plugin-specific movement keys
---
--- @param  ctx color-board.ctx The context containing dashboard and keymap info
function M.register_keymap(ctx)
  -- unregister default movement keymaps
  local move_keys = { "w", "f", "b", "h", "j", "k", "l", "t", "<Up>", "<Down>", "<Left>", "<Right>" }
  vim.tbl_map(function(k) vim.keymap.set("n", k, "<Nop>", { buffer = ctx.buf }) end, move_keys)

  -- register 'k' to move up through keymaps
  vim.keymap.set(
    "n",
    "k",
    function()
      ctx.pos = (ctx.pos - 1) % #ctx.opts.keymaps
      vim.api.nvim_win_set_cursor(0, { ctx.keys_row + ctx.pos, ctx.keys_column })
    end,
    { buffer = ctx.buf }
  )

  -- register 'j' to move down through keymaps
  vim.keymap.set(
    "n",
    "j",
    function()
      ctx.pos = (ctx.pos + 1) % #ctx.opts.keymaps
      vim.api.nvim_win_set_cursor(0, { ctx.keys_row + ctx.pos, ctx.keys_column })
    end,
    { buffer = ctx.buf }
  )

  -- execute the function under the cursor when Enter is pressed
  vim.keymap.set("n", "<Enter>", function() vim.api.nvim_input(ctx.opts.keymaps[ctx.pos + 1].key) end)

  -- register all configured plugin keymaps
  for _, keymap in ipairs(ctx.opts.keymaps) do
    vim.keymap.set(
      "n",
      keymap.key,
      type(keymap.func) == "function" and    -- either lua function or string
      keymap.func or                         -- lua function
      function()                             --
        ---@diagnostic disable-next-line     --
        local dump = loadstring(keymap.func) -- try loading function from string
        if not dump then                     --
          vim.cmd(keymap.func)               -- run cmd
        else                                 --
          dump()                             -- run function
        end
      end,
      { desc = keymap.description, buffer = ctx.buf, nowait = true, silent = true }
    )
  end
end

--- Creates a table of strings representing the rendered keymaps
---
--- @param ctx color-board.ctx  The context containing dashboard and keymap info
--- @return string[]            A list of rendered keymap strings
function M.render_keymaps(ctx)
  local keys_render = {}

  -- fill spacing between dashboard and keymaps
  for i = 1, ctx.opts.space do keys_render[i] = "" end

  for _, keybind in ipairs(ctx.opts.keymaps) do
    -- 8: 4 ->  2 spaces, icon, space
    --    4 ->     space,    [,   key,  ]
    table.insert(keys_render,
      "  " .. keybind.icon .. " " ..
      keybind.description .. string.rep(ctx.opts.filler, ctx.opts.keymap_width - #keybind.description - 8) ..
      " [" .. keybind.key .. "]")
  end

  return keys_render
end

--- Returns whether the given dashboard fits within the current window
---
--- @param ctx color-board.ctx        The context containing dashboard and keymap info
--- @param db color-board.dashboard?  Optional. The dashboard to check. Defaults to the current dashboard if nil
--- @return boolean                   True if the dashboard fits in the window, false otherwise
function M.is_valid(ctx, db)
  db = db or ctx.opts.dashboards[ctx.current]

  local max_height = vim.o.lines - (ctx.opts.margin * 2 + #ctx.keys_render)
  local max_width = vim.o.columns - (ctx.opts.margin * 2)

  return db.width <= max_width and db.height <= max_height
end

return M
