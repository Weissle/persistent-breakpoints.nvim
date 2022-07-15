local cfg = require('persistent-breakpoints.config')
local M = {}

M.create_path = function(path)
	vim.fn.mkdir(path, "p")
end

M.get_bps_path = function ()
	assert(type(cfg.config) == 'table', 'Use persistent-breakpoints functions but not setup!')
	local cp_filename = (vim.fn.getcwd()):gsub('/','_') .. '.json'
	return cfg.config.save_dir .. '/' .. cp_filename
end

M.load_bps = function (path)
	assert(type(cfg.config) == 'table', 'Use persistent-breakpoints functions but not setup!')
	local fp = io.open(path,'r')
	local bps = {}
	if fp ~= nil then
		local load_bps_raw = fp:read('*a')
		bps = vim.fn.json_decode(load_bps_raw)
		fp:close()
	end
	return bps
end

M.write_bps = function (path, bps)
	bps = bps or {}
	assert(type(cfg.config) == 'table', 'Use persistent-breakpoints functions but not setup!')
	assert(type(bps) == 'table', "The persistent breakpoints should be stored in a table. Usually it is not the user's problem if you did not call the write_bps function explicitly.")

	local fp = io.open(path, 'w+')
	if fp == nil then
		vim.notify('Failed to save checkpoints. File: ' .. vim.fn.expand('%'), 'WARN')
		return false
	else
		fp:write(vim.fn.json_encode(bps))
		fp:close()
		return true
	end
end

return M
