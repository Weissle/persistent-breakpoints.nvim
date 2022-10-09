local utils = require("persistent-breakpoints.utils")
local inmem_bps = require("persistent-breakpoints.inmemory")
local cfg = require("persistent-breakpoints.config")

local M = {}

M.setup = function(_cfg)
	_cfg = _cfg or {}
	local tmp_config = vim.tbl_deep_extend("force", cfg, _cfg)
	for key, val in pairs(tmp_config) do
		cfg[key] = val
	end
	inmem_bps.bps = utils.load_bps(utils.get_bps_path()) -- {'filename':breakpoints_table}
	utils.create_path(cfg.save_dir)
	if tmp_config.load_breakpoints_event ~= nil then
		local aug = vim.api.nvim_create_augroup("persistent-breakpoints-load-breakpoint", {
			clear = true,
		})
		vim.api.nvim_create_autocmd(
			tmp_config.load_breakpoints_event,
			{ callback = require("persistent-breakpoints.api").load_breakpoints, group = aug }
		)
	end
end

return M
