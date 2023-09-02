local utils = require('persistent-breakpoints.utils')
local config = require('persistent-breakpoints.config')
local inmemory_bps = require('persistent-breakpoints.inmemory')
local breakpoints = require('dap.breakpoints')

local F = {}

F.breakpoints_changed_in_current_buffer = function()
	local current_buf_file_name = vim.api.nvim_buf_get_name(0)
	local current_buf_id = vim.api.nvim_get_current_buf()
	local current_buf_breakpoints = breakpoints.get()[current_buf_id]
	if #current_buf_file_name == 0 then
		return
	end
	inmemory_bps.bps[current_buf_file_name] = current_buf_breakpoints
	inmemory_bps.changed = true
	local write_ok = utils.write_bps(utils.get_bps_path(),inmemory_bps.bps)
	inmemory_bps.changed = not write_ok
end

F.call_and_update = function (func)
	func()
	F.breakpoints_changed_in_current_buffer()
end

F.toggle_breakpoint = function ()
	F.call_and_update(require('dap').toggle_breakpoint)
end

F.set_conditional_breakpoint = function ()
	F.call_and_update(function ()
		require('dap').set_breakpoint(vim.fn.input('[Condition] > '));
	end)
end

F.clear_all_breakpoints = function ()
	breakpoints.clear()
	inmemory_bps.bps = {}
	inmemory_bps.changed = true
	local write_ok = utils.write_bps(utils.get_bps_path(),inmemory_bps.bps)
	inmemory_bps.changed = not write_ok
end

F.store_breakpoints = function (clear)
	if clear == nil then
		local tmp_fbps = vim.deepcopy(inmemory_bps.bps)
		for bufid, bufbps in pairs(breakpoints.get()) do
			tmp_fbps[vim.api.nvim_buf_get_name(bufid)] = bufbps
		end
		utils.write_bps(utils.get_bps_path(),tmp_fbps)
	else
		vim.notify_once('The store_breakpoints function will not accept parameters in the future. If you want to clear all breakpoints, you should the use clear_all_breakpoints function.','WARN')
		if clear == true then
			F.clear_all_breakpoints()
		else
			F.store_breakpoints(nil)
		end
	end
end

F.load_breakpoints = function()
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
			if config.on_load_breakpoint ~= nil then
				config.on_load_breakpoint(opts, buf_id, line)
			end
		end
	end
end

F.reload_breakpoints = function ()
	inmemory_bps.bps = utils.load_bps(utils.get_bps_path())
	inmemory_bps.changed = false
	breakpoints.clear()
	F.load_breakpoints()
end

local perf_data = {}

local M = {}

for func_name, func_body in pairs(F) do
	M[func_name] = function ()
		if config.perf_record then
			local start_time = vim.fn.reltimefloat(vim.fn.reltime())
			func_body()
			local end_time = vim.fn.reltimefloat(vim.fn.reltime())
			perf_data[func_name] = end_time - start_time
		else
			func_body()
		end
	end
end

M.print_perf_data = function ()
	local result = ''
	for fn, fd in pairs(perf_data) do
		local ms = math.floor(fd*1e6+0.5)/1e3
		local str = fn .. ': ' .. tostring(ms) .. 'ms\n'
		result = result .. str
	end
	print(result)
end

return M
