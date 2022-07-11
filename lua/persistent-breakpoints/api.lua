local Ut = require('persistent-breakpoints.utils')
local breakpoints = require('dap.breakpoints')

local M = {}

M.store_breakpoints = function (clear)
	local bps_path,fbps = Ut.get_bps_path(),_G.fpbps
	if clear == nil or clear == false then
		local current_buf_file_name = vim.api.nvim_buf_get_name(0)
		local current_buf_id = vim.api.nvim_get_current_buf()
		local current_buf_breakpoints = breakpoints.get()[current_buf_id]
		fbps[current_buf_file_name] = current_buf_breakpoints
	end
	local fp = io.open(bps_path, 'w+')
	if fp == nil then
		vim.notify('Failed to save checkpoints. File: ' .. vim.fn.expand('%'), 'WARN')
		return
	else
		fp:write(vim.fn.json_encode(fbps))
		fp:close()
	end
end


M.load_breakpoints = function()
	local bbps = breakpoints.get()
	local fbps = _G.fpbps
	local new_loaded_bufs = {}
	-- Find the new loaded buffer.
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local file_name = vim.api.nvim_buf_get_name(buf)
		-- if bbps[buf] != nil => this file's breakpoints have been loaded.
		-- if vim.tbl_isempty(bps[file_name] or {}) => This file have no saved breakpoints.
		if bbps[buf] == nil and vim.tbl_isempty(fbps[file_name] or {}) == false then
			new_loaded_bufs[file_name] = buf
		end
	end
	for file_name, buf_id in pairs(new_loaded_bufs) do
		for _, bp in pairs(fbps[file_name]) do
			local line = bp.line
			local opts = {
				condition = bp.condition,
				log_message = bp.logMessage,
				hit_condition = bp.hitCondition
			}
			breakpoints.set(opts, buf_id, line)
		end
	end
end

M.reload_breakpoints = function ()
	_G.fpbps = Ut.load_bps(Ut.get_bps_path())
	breakpoints.clear()
	M.load_breakpoints()
end

return M
