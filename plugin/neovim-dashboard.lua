local vim = {}

if vim.g.loaded_neovim_dashboard then
	return
end

vim.g.loaded_neovim_dashboard = true

-- to do
-- create a callback
vim.api.nvim_create_autocmd("UIEnter", {})

vim.api.nvim_create_user_command("Dashboard", function()
	require("neovim-dashboard"):show()
end, {})
