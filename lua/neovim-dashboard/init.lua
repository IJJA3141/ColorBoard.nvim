local M = {}

---@type config
local default_opts = {
	keybinds = {
		{
			icon = "!",
			key = "g",
			description = "say something ?",
			func = function()
				print("hello world !")
			end,
		},
	},
	dashboards = { {
		width = 1,
		height = 1,
		colors = false,
		ascii = "No config ?",
	} },
}

function M:show()
	self:get_valid()

	local row = 2
	local col = math.floor((vim.o.columns - 100) / 2)

	local opts = {
		relative = "win",
		row = 0,
		col = 0,
		width = vim.api.nvim_win_get_width(0),
		height = vim.api.nvim_win_get_height(0),
		style = "minimal",
		noautocmd = true,
	}

	self.bufnr = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("filetype", "dashboard", { buf = self.bufnr })

	self.winID = vim.api.nvim_open_win(self.bufnr, false, opts)
	vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, { "1", "2", "3", "4" })
	vim.api.nvim_set_option_value("modifiable", false, { buf = self.bufnr })
end

function M:get_valid()
	self.valid = {}

	for _, dashboard in ipairs(self.opts.dashboards) do
		if dashboard.width <= vim.api.nvim_win_get_width(0) then
			if dashboard.height <= vim.api.nvim_win_get_height(0) - (#self.opts.keybinds * 2 + 1) then
				table.insert(self.valid, dashboard)
			end
		end
	end
end

function M.setup(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("force", default_opts, opts)
end

return M
