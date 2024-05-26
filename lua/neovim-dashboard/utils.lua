local utils = {}

function utils.buf_is_empty(bufnr)
	bufnr = bufnr or 0
	return vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == ""
end

return utils
