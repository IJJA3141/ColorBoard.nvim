-- luacheck: push ignore vim
local utils = {}

function utils.buf_is_empty(bufnr)
	bufnr = bufnr or 0
	return vim.api.nvim_buf_line_count(bufnr) == 1 and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
end

function utils.disable_move_key(bufnr)
	local keys = { "w", "f", "b", "h", "j", "k", "l", "<Up>", "<Down>", "<Left>", "<Right>" }
	vim.tbl_map(function(k)
		vim.keymap.set("n", k, "<Nop>", { buffer = bufnr })
	end, keys)
end

function utils.set_move_key(bufnr, win, offset_left, offset_top, keybind_number)
	local index = -1
	local fn = function()
		index = index + 2

		if index >= keybind_number and index ~= -1 then
			index = 1
		end

		vim.api.nvim_win_set_cursor(win, { offset_top + index, math.ceil(offset_left) - 1 })
	end

	vim.keymap.set("n", "j", fn, { buffer = bufnr })

	fn()
end

return utils
-- luacheck: pop
