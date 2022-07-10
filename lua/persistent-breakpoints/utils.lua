local M = {}

M.tableMerge = function(t1, t2)
	for k,v in pairs(t2) do
		if type(v) == "table" and type(t1[k]) == 'table' then
			M.tableMerge(t1[k] or {}, t2[k] or {})
		else
			t1[k] = v
		end
	end
	return t1
end

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
