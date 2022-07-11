
command! PBReload lua require('persistent-breakpoints.api').reload_breakpoints()
command! PBStore lua require('persistent-breakpoints.api').store_breakpoints()
command! PBLoad lua require('persistent-breakpoints.api').load_breakpoints()
