local utils = require('persistent-breakpoints.utils')
local inmem_bps = require('persistent-breakpoints.inmemory')
local cfg = require('persistent-breakpoints.config')
local M = {}

M.setup = function(_cfg)
	cfg.config = vim.tbl_deep_extend('force',cfg.default_cfg,_cfg or {})
	inmem_bps.bps = utils.load_bps(utils.get_bps_path()) -- {'filename':breakpoints_table}
	utils.create_path(cfg.config.save_dir)
end

return M
