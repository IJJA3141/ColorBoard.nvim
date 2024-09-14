-- luacheck: push ignore vim
local utils = require("neovim-dashboard.utils")

local M = {
	--- @type line[]
	keybinds = {},
	--- @type string[]
	keyframe = {},

	--- @type config
	opts = nil,
	key = nil,

	index = 0,
}

---@type strict_config
local default_opts = {
	top_margin = 2,
	center_margin = 2,
	keybind_padding = 2,
	bottom_min_margin = 2,
	keybind_max_width = 76,
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
			width = 8,
			height = 1,
			colors = true,
			ascii = { "\x1B[36m[NEOVIM]\x1B[0m" },
		},
	},
}

function M.setup(opts, baleia)
	opts = opts or {}
	baleia = baleia or {}

	M.opts = vim.tbl_extend("force", default_opts, opts)
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

	self:register_keybinds()
	self:get_valid()
	self:render_keybinds()
end

function M:register_keybinds()
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

		local line = {}
		line.icon = self.opts.keybinds[i].icon
		line.left = self.opts.keybinds[i].description
		line.right = "[" .. self.opts.keybinds[i].key .. "]"

		table.insert(self.keybinds, line)
	end
end

function M:render_keybinds()
	self.keyframe = {}

	if #self.keybinds ~= 0 and self.key ~= -1 then
		if self.opts.dashboards[self.key].width >= self.opts.keybind_max_width then
			table.insert(
				self.keyframe,
				self.keybinds[1].icon
					.. " "
					.. self.keybinds[1].left
					.. string.rep(
						" ",
						self.opts.keybind_max_width
							- #self.keybinds[1].left
							- #self.keybinds[1].right
							- 2
							- self.opts.keybind_padding * 2
					)
					.. self.keybinds[1].right
			)

			for i = 2, #self.keybinds do
				table.insert(self.keyframe, "")
				table.insert(
					self.keyframe,
					self.keybinds[i].icon
						.. " "
						.. self.keybinds[i].left
						.. string.rep(
							" ",
							self.opts.keybind_max_width
								- #self.keybinds[i].left
								- #self.keybinds[i].right
								- 2
								- self.opts.keybind_padding * 2
						)
						.. self.keybinds[i].right
				)
			end
		else
			table.insert(
				self.keyframe,
				self.keybinds[1].icon
					.. " "
					.. self.keybinds[1].left
					.. string.rep(
						" ",
						self.opts.dashboards[self.key].width
							- #self.keybinds[1].left
							- #self.keybinds[1].right
							- 2
							- self.opts.keybind_padding * 2
					)
					.. self.keybinds[1].right
			)

			for i = 2, #self.keybinds do
				table.insert(self.keyframe, "")
				table.insert(
					self.keyframe,
					self.keybinds[i].icon
						.. " "
						.. self.keybinds[i].left
						.. string.rep(
							" ",
							self.opts.dashboards[self.key].width
								- #self.keybinds[i].left
								- #self.keybinds[1].right
								- 2
								- self.opts.keybind_padding * 2
						)
						.. self.keybinds[i].right
				)
			end
		end
	end
end

function M:get_valid()
	local valid_keys = {}

	for key, dashboard in pairs(self.opts.dashboards) do
		if
			dashboard.width <= vim.api.nvim_win_get_width(0)
			and dashboard.height
					+ #self.opts.keybinds * 2
					- 1
					+ self.opts.top_margin
					+ self.opts.center_margin
					+ self.opts.bottom_min_margin
				<= vim.api.nvim_win_get_height(0)
		then
			table.insert(valid_keys, key)
		end
	end

	if #valid_keys == 0 then
		print("not matching dashboard /!\\")
		self.key = -1
	else
		self.key = valid_keys[math.random(1, #valid_keys)]
	end
end

function M:render()
	if
		self.key == -1
		or self.opts.dashboards[self.key].width > vim.api.nvim_win_get_width(0)
		or self.opts.dashboards[self.key].height > vim.api.nvim_win_get_height(0)
	then
		self:get_valid()
		self:render_keybinds()
	end

	if self.key ~= -1 then
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

		if #self.keyframe ~= 0 then
			horizontal_margin = (vim.api.nvim_win_get_width(0) - #self.keyframe[1]) / 2

			for j = 1, #self.keyframe do
				centered_keybinds[j] = string.rep(" ", horizontal_margin + 1)
				centered_keybinds[j] = centered_keybinds[j] .. self.keyframe[j]
			end

			utils.set_move_key(
				self.bufnr,
				self.winid,
				horizontal_margin,
				self.opts.top_margin + #centered_dashboard + self.opts.center_margin,
				self.opts.keybinds
			)
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

		vim.api.nvim_input("j")
	end

	vim.bo[self.bufnr].modifiable = false
	vim.bo[self.bufnr].modified = false
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

function M:close()
	if self.bufnr and vim.api.nvim_buf_is_loaded(self.bufnr) then
		vim.api.nvim_buf_delete(self.bufnr, { force = true })
	end

	if self.winid and vim.api.nvim_win_is_valid(self.winid) then
		vim.api.nvim_win_close(self.winid, true)
	end
end

return M

-- luacheck: pop
