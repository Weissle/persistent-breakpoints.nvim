local Ut = require('persistent-breakpoints.utils')
local M = {}
local default_cfg = {
	save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints'
}

M.setup = function(_cfg)
	_G.pbps_cfg = vim.tbl_deep_extend('force',default_cfg,_cfg or {})
	_G.fpbps = Ut.load_bps(Ut.get_bps_path()) -- {'filename':breakpoints_table}
	Ut.create_path(_G.pbps_cfg.save_dir)
end

return M
