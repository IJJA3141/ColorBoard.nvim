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

return utils
