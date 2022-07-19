
command! PBToggleBreakpoint lua require('persistent-breakpoints.api').toggle_breakpoint()
command! PBSetConditionalBreakpoint lua require('persistent-breakpoints.api').set_conditional_breakpoint()
command! PBClearAllBreakpoints lua require('persistent-breakpoints.api').clear_all_breakpoints()

command! PBReload lua require('persistent-breakpoints.api').reload_breakpoints(); vim.notify_once("Command PBReload will be removed in the future since we don't recommand using it directively. But you still can use it by lua module if you really like it.","WARN")
command! PBStore lua require('persistent-breakpoints.api').store_breakpoints(false) vim.notify_once("Command PBStore will be removed in the future since we don't recommand using it directively. But you still can use it by lua module if you really like it.","WARN")
command! PBLoad lua require('persistent-breakpoints.api').load_breakpoints() vim.notify_once("Command PBLoad will be removed in the future since we don't recommand using it directively. But you still can use it by lua module if you really like it.","WARN")
