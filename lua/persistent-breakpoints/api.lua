local utils = require('persistent-breakpoints.utils')
local inmemory_bps = require('persistent-breakpoints.inmemory')
local breakpoints = require('dap.breakpoints')

local function breakpoints_changed_in_current_buffer()
	local current_buf_file_name = vim.api.nvim_buf_get_name(0)
	local current_buf_id = vim.api.nvim_get_current_buf()
	local current_buf_breakpoints = breakpoints.get()[current_buf_id]
	inmemory_bps.bps[current_buf_file_name] = current_buf_breakpoints
	inmemory_bps.changed = true
	local write_ok = utils.write_bps(utils.get_bps_path(),inmemory_bps.bps)
	inmemory_bps.changed = not write_ok
end

local M = {}

M.toggle_breakpoint = function ()
	require('dap').toggle_breakpoint();
	breakpoints_changed_in_current_buffer()
end

M.set_conditional_breakpoint = function ()
	require('dap').set_breakpoint(vim.fn.input('[Condition] > '));
	breakpoints_changed_in_current_buffer()
end

M.clear_all_breakpoints = function ()
	breakpoints.clear()
	inmemory_bps.bps = {}
	inmemory_bps.changed = true
	local write_ok = utils.write_bps(utils.get_bps_path(),inmemory_bps.bps)
	inmemory_bps.changed = not write_ok
end

M.store_breakpoints = function (clear)
	if clear == nil then
		local tmp_fbps = vim.deepcopy(inmemory_bps.bps)
		for bufid, bufbps in pairs(breakpoints.get()) do
			tmp_fbps[vim.api.nvim_buf_get_name(bufid)] = bufbps
		end
		utils.write_bps(utils.get_bps_path(),tmp_fbps)
	else
		vim.notify_once('The store_breakpoints function will not accept parameters in the future. If you want to clear all breakpoints, you should the use clear_all_breakpoints function.','WARN')
		if clear == true then
			M.clear_all_breakpoints()
		else
			M.store_breakpoints(nil)
		end
	end
end

M.load_breakpoints = function()
	local bbps = breakpoints.get()
	local fbps = inmemory_bps.bps
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
	inmemory_bps.bps = utils.load_bps(utils.get_bps_path())
	inmemory_bps.changed = false
	breakpoints.clear()
	M.load_breakpoints()
end

return M
