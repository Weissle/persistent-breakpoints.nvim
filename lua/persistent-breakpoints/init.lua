local utils = require('persistent-breakpoints.utils')
local inmem_bps = require('persistent-breakpoints.inmemory')
local cfg = require('persistent-breakpoints.config')
local M = {}

M.setup = function(_cfg)
	local tmp_config = vim.tbl_deep_extend('force',cfg,_cfg)
	for key,val in pairs(tmp_config) do
		cfg[key] = val
	end
	vim.fn.extend(cfg,_cfg or {},'force')
	inmem_bps.bps = utils.load_bps(utils.get_bps_path()) -- {'filename':breakpoints_table}
	utils.create_path(cfg.save_dir)
end

return M
