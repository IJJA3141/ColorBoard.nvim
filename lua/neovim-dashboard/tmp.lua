-- tmp
local vim = {}
local utils = require("utils")

local M = {}
local default_opts = {}

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

	self:get_valid()
end

function M:get_valid()
	local valid_idxs = {}
	for idx = 1, #self.opts.dashboards + 1 do
		if
			self.opts.dashboards[idx].width <= vim.api.nvim_win_get_width(self.bufnr)
			and self.opts.dashboards[idx].height <= vim.api.nvim_win_get_height(self.bufnr)
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
		self.opts.dashboards[self.idx].width > vim.api.nvim_win_get_width(self.bufnr)
		or self.opts.dashboards[self.idx].height > vim.api.nvim_win_get_height(self.bufnr)
	then
		self:get_valid()
	end

	-- to do center things
	-- <-

	vim.bo[self.bufnr].modifiable = true
	if self.opts.dashboards[self.idx].colors then
		self.baleia.buf_set_lines(self.bufnr, 0, -1, true, self.opts.dashboards[self.idx].ascii)
	else
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, self.opts.dashboards[self.idx].ascii)
	end
	vim.bo[self.bufnr].modifiable = false
end

return M
