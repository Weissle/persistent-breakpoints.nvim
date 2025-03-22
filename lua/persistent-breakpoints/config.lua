local config = {}

config = {
	save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
	load_breakpoints_event = nil,
	perf_record = false,
	on_load_breakpoint = nil,
	always_reload = false,
}

return config

