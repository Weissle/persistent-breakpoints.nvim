local Ut = require('utils')
local breakpoints = require('dap.breakpoints')

local M = {}
local default_cfg = {
	save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints'
}

M.setup = function(_cfg)
	_G.pbps_cfg = Ut.tableMerge(default_cfg,_cfg or {})
	Ut.create_path(_G.pbps_cfg.save_dir)
end

M.store_breakpoints = function (clear)
	local bps_path,bps = Ut.get_bps_path(),{}
	if clear == nil or clear == false then
		bps = Ut.load_bps(bps_path)
		local current_buf_file_name = vim.api.nvim_buf_get_name(0)
		local current_buf_id = vim.api.nvim_get_current_buf()
		local current_buf_breakpoints = breakpoints.get()[current_buf_id]
		bps[current_buf_file_name] = current_buf_breakpoints
	end
	local fp = io.open(bps_path, 'w+')
	if fp == nil then
		require('common').async_notify('Failed to save checkpoints. File: ' .. vim.fn.expand('%'), 'WARN')
		return
	else
		fp:write(vim.fn.json_encode(bps))
		fp:close()
	end
end


M.load_breakpoints = function()
	local bps_path = Ut.get_bps_path()
	local bps = Ut.load_bps(bps_path)
	breakpoints.clear()
	local loaded_buffers = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local file_name = vim.api.nvim_buf_get_name(buf)
		if (bps[file_name] ~= nil and bps[file_name] ~= {}) then
			loaded_buffers[file_name] = buf
		end
	end
	for path, buf_bps in pairs(bps) do
		if loaded_buffers[path] ~= nil then
			for _, bp in pairs(buf_bps) do
				local line = bp.line
				local opts = {
					condition = bp.condition,
					log_message = bp.logMessage,
					hit_condition = bp.hitCondition
				}
				breakpoints.set(opts, tonumber(loaded_buffers[path]), line)
			end
		end

	end
end

return M
