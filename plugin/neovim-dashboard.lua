if vim.g.loaded_neovim_dashboard then
	return
end

vim.g.loaded_neovim_dashboard = 1

vim.api.nvim_create_autocmd("UIEnter", {
	group = vim.api.nvim_create_augroup("Dashboard", { clear = true }),
	callback = function()
		if
			vim.fn.argc() == 0
			and vim.api.nvim_buf_line_count(0) == 1
			and vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == ""
		then
			require("neovim-dashboard"):open()
		end
	end,
})

vim.api.nvim_create_user_command("Dashboard", function()
	require("neovim-dashboard"):open()
end, {})
