local M = {}

M.create_path = function(path)
	os.execute('mkdir -p ' .. path)
end

M.get_bps_path = function ()
	assert(type(_G.pbps_cfg) == 'table', 'Use persistent-breakpoints functions but not setup!')
	local cp_filename = (vim.fn.getcwd()):gsub('/','_') .. '.json'
	return _G.pbps_cfg.save_dir .. '/' .. cp_filename
end

M.load_bps = function (path)
	assert(type(_G.pbps_cfg) == 'table', 'Use persistent-breakpoints functions but not setup!')
	local fp = io.open(path,'r')
	local bps = {}
	if fp ~= nil then
		local load_bps_raw = fp:read('*a')
		bps = vim.fn.json_decode(load_bps_raw)
		fp:close()
	end
	return bps
end

return M
