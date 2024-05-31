-- utils
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
	keybinds = {
		{
			key = "d",
			func = function()
				vim.cmd("q")
			end,
			icon = "",
			description = ":q",
		},
	},
	dashboards = { {
		width = 20,
		height = 1,
		colors = false,
		ascii = { "no config ? ಠಿ_ಠ" },
	} },
}

--- @param opts config
--- @return nil
function M.setup(opts)
	opts = opts or {}
	---@type config
	M.opts = vim.tbl_deep_extend("force", default_opts, opts)
	M.baleia = require("baleia").setup()
end

function M:init()
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
	}
	for opt, val in pairs(opts) do
		vim.opt_local[opt] = val
	end

	--[[
	vim.api.nvim_create_autocmd("WinResized", {
		callback = function()
			require("test.init"):render()
		end,
	})
  --]]

	vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			require("test.init"):render()
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
		elseif type(self.opts.keybinds[i].func) == "string" then
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
	local valid_idxs = {}
	for idx = 1, #self.opts.dashboards do
		if
			self.opts.dashboards[idx].width <= vim.api.nvim_win_get_width(0)
			and self.opts.dashboards[idx].height <= vim.api.nvim_win_get_height(0)
		then
			table.insert(valid_idxs, idx)
		end
	end

	if #valid_idxs == 0 then
		print("not matching dashboard );")
		return
	end

	self.idx = valid_idxs[math.random(1, #valid_idxs)]
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
		self.opts.dashboards[self.idx].width > vim.api.nvim_win_get_width(0)
		or self.opts.dashboards[self.idx].height > vim.api.nvim_win_get_height(0)
	then
		self:get_valid()
	end

	---@type string[]
	local centered_dashboard = {}
	local horizontal_margin = (vim.api.nvim_win_get_width(0) - self.opts.dashboards[self.idx].width) / 2

	for j = 1, self.opts.dashboards[self.idx].height do
		centered_dashboard[j] = ""
		for i = 1, horizontal_margin do
			centered_dashboard[j] = centered_dashboard[j] .. " "
		end
		centered_dashboard[j] = centered_dashboard[j] .. self.opts.dashboards[self.idx].ascii[j]
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
	if self.opts.dashboards[self.idx].colors then
		self.baleia.buf_set_lines(self.bufnr, 0, -1, true, centered_dashboard)
	else
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, centered_dashboard)
		for i = 0, self.opts.dashboards[self.idx].height do
			vim.api.nvim_buf_add_highlight(self.bufnr, 0, "DashboardHeader", i, 0, -1)
		end
	end

	vim.api.nvim_buf_set_lines(self.bufnr, -1, -1, true, centered_keybinds)

	for i = 1, self.opts.center_margin do
		vim.api.nvim_buf_set_lines(
			self.bufnr,
			self.opts.dashboards[self.idx].height,
			self.opts.dashboards[self.idx].height,
			true,
			{ "" }
		)
	end

	for i = 1, self.opts.top_margin do
		vim.api.nvim_buf_set_lines(self.bufnr, 0, 0, true, { "" })
	end

	vim.bo[self.bufnr].modifiable = false
end

return M
