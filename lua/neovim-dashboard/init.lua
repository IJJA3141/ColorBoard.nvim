local utils = require("neovim-dashboard.utils")

local M = {
	---@type string[]
	keybinds = {},
}

---@type  config
local default_opts = {
	top_margin = 2,
	center_margin = 2,
	bottom_margin = 2,
	keybind_width = 30,
	keybind_margin = 0,
	keybinds = {
		{
			key = "q",
			func = "q",
			icon = "",
			description = ":q",
		},
	},
	dashboards = {
		default = {
			width = 15,
			height = 1,
			colors = false,
			ascii = { "no config ? ಠಿ_ಠ" },
		},
	},
}

function M.setup(opts, baleia)
	opts = opts or {}
	baleia = baleia or {}

	M.opts = vim.tbl_deep_extend("force", default_opts, opts)
	M.baleia = require("baleia").setup(baleia)
end

function M:init()
	self.opts = self.opts or default_opts

	if not utils.buf_is_empty(0) then
		self.bufnr = vim.api.nvim_create_buf(false, true)
	else
		self.bufnr = vim.api.nvim_get_current_buf()
	end

	self.winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(self.winid, self.bufnr)

	self.user_cursor_line = vim.opt.cursorline:get()

	local opts = {
		["bufhidden"] = "wipe",
		["colorcolumn"] = "",
		["foldcolumn"] = "0",
		["matchpairs"] = "",
		["buflisted"] = false,
		["cursorcolumn"] = false,
		["cursorline"] = false,
		["list"] = false,
		["number"] = false,
		["relativenumber"] = false,
		["spell"] = false,
		["swapfile"] = false,
		["readonly"] = false,
		["filetype"] = "dashboard",
		["wrap"] = false,
		["signcolumn"] = "no",
		["winbar"] = "",
		["stc"] = "",
	}
	for opt, val in pairs(opts) do
		vim.opt_local[opt] = val
	end

	vim.api.nvim_create_autocmd("VimResized", {
		buffer = self.bufnr,
		callback = function()
			require("neovim-dashboard"):render()
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(opt)
			local bufs = vim.api.nvim_list_bufs()
			bufs = vim.tbl_filter(function(k)
				return vim.bo[k].filetype == "dashboard"
			end, bufs)
			if #bufs == 0 then
				pcall(vim.api.nvim_del_autocmd, opt.id)
			end
		end,
		desc = "[Dashboard] clean dashboard data reduce memory",
	})

	-- keybinds
	utils.disable_move_key(self.bufnr)
	for i = 1, #self.opts.keybinds do
		if type(self.opts.keybinds[i].func) == "string" then
			vim.keymap.set("n", self.opts.keybinds[i].key, function()
				local dump = loadstring(self.opts.keybinds[i].func)
				if not dump then
					vim.cmd(self.opts.keybinds[i].func)
				else
					dump()
				end
			end, { desc = self.opts.keybinds[i].description, buffer = self.bufnr, nowait = true, silent = true })
		elseif type(self.opts.keybinds[i].func) == "function" then
			vim.keymap.set(
				"n",
				self.opts.keybinds[i].key,
				self.opts.keybinds[i].func,
				{ desc = self.opts.keybinds[i].description, buffer = self.bufnr, nowait = true, silent = true }
			)
		end

		local line = ""
		line = line .. self.opts.keybinds[i].icon .. " " .. self.opts.keybinds[i].description
		for j = 1, self.opts.keybind_width - #self.opts.keybinds[i].description do
			line = line .. " "
		end
		line = line .. "[" .. self.opts.keybinds[i].key .. "]"

		table.insert(self.keybinds, line)
	end

	self:get_valid()
end

function M:get_valid()
	local valid_keys = {}

	for key, dashboard in ipairs(self.opts.dashboards) do
		print(key)
		if dashboard.width <= vim.api.nvim_win_get_width(0) and dashboard.height <= vim.api.nvim_win_get_height(0) then
			table.insert(valid_keys, key)
		end
	end

	print(self.opts.top_margin)
	print(self.opts.dashboards.default.ascii[1])

	if #valid_keys == 0 then
		print("not matching dashboard );")
		return
	end

	self.key = valid_keys[math.random(1, #valid_keys)]
end

function M:open()
	local mode = vim.api.nvim_get_mode()
	if mode == "i" or not vim.bo.modifiable then
		return
	end

	if not vim.o.hidden and vim.bo.modified then
		--save before open
		vim.cmd.write()
		return
	end

	self:init()
	self:render()
end

function M:render()
	if
		self.opts.dashboards[self.key].width > vim.api.nvim_win_get_width(0)
		or self.opts.dashboards[self.key].height > vim.api.nvim_win_get_height(0)
	then
		self:get_valid()
	end

	local centered_dashboard = {}
	local horizontal_margin = (vim.api.nvim_win_get_width(0) - self.opts.dashboards[self.key].width) / 2

	for j = 1, self.opts.dashboards[self.key].height do
		centered_dashboard[j] = ""
		for i = 1, horizontal_margin do
			centered_dashboard[j] = centered_dashboard[j] .. " "
		end
		centered_dashboard[j] = centered_dashboard[j] .. self.opts.dashboards[self.key].ascii[j]
	end

	local centered_keybinds = {}
	horizontal_margin = (vim.api.nvim_win_get_width(0) - self.opts.keybind_width) / 2

	for j = 1, #self.keybinds do
		centered_keybinds[j] = ""
		for i = 1, horizontal_margin do
			centered_keybinds[j] = centered_keybinds[j] .. " "
		end
		centered_keybinds[j] = centered_keybinds[j] .. self.keybinds[j]
	end

	vim.bo[self.bufnr].modifiable = true

	for i = 1, self.opts.top_margin do
		vim.api.nvim_buf_set_lines(self.bufnr, 0, 0, true, { "" })
	end

	if self.opts.dashboards[self.key].colors then
		self.baleia.buf_set_lines(self.bufnr, self.opts.top_margin, -1, true, centered_dashboard)
	else
		vim.api.nvim_buf_set_lines(self.bufnr, self.opts.top_margin, -1, true, centered_dashboard)
		for i = 0, self.opts.dashboards[self.key].height do
			vim.api.nvim_buf_add_highlight(self.bufnr, 0, "DashboardHeader", i + self.opts.top_margin, 0, -1)
		end
	end

	vim.api.nvim_buf_set_lines(self.bufnr, -1, -1, true, centered_keybinds)

	for i = 1, self.opts.center_margin do
		vim.api.nvim_buf_set_lines(
			self.bufnr,
			self.opts.dashboards[self.key].height + self.opts.top_margin,
			self.opts.dashboards[self.key].height + self.opts.top_margin,
			true,
			{ "" }
		)
	end

	vim.bo[self.bufnr].modifiable = false
	vim.bo[self.bufnr].modified = false
end

function M:close()
	if self.bufnr and vim.api.nvim_buf_is_loaded(self.bufnr) then
		vim.api.nvim_buf_delete(self.bufnr, { force = true })
	end

	if self.winid and vim.api.nvim_win_is_valid(self.winid) then
		vim.api.nvim_win_close(self.winid, true)
	end
end

return M
