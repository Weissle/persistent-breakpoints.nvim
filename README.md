# Persistent checkpoints 
persistent-breakpoints is a lua plugin for Neovim to save the [nvim-dap](https://github.com/mfussenegger/nvim-dap)'s checkpoints to file and automatically load them when you open neovim. It is based on the code in [here](https://github.com/mfussenegger/nvim-dap/issues/198), but has better performance and some bugs are fixed.

**This is a simple and stable plugin. It is not supposed to have frequent update. You can feel free to use this plugin if there is no issue or PR in this repo.**  

:star: Your stars are my biggest motivation.

## Install
### with `packer.nvim`  
`use {'Weissle/persistent-breakpoints.nvim'}`  
### or with `vim-plug`  
`Plug 'Weissle/persistent-breakpoints.nvim'`

## Setup
```lua
require('persistent-breakpoints').setup{
	load_breakpoints_event = { "BufReadPost" }
} -- use default config
```
Below is the default config, you can change it according to your need.
```lua
require('persistent-breakpoints').setup{
	save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
	-- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
	perf_record = false,
} 
```
## Usage
```lua
-- automatically load breakpoints when a file is loaded into the buffer.
vim.api.nvim_create_autocmd({"BufReadPost"},{ callback = require('persistent-breakpoints.api').load_breakpoints })

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- Save breakpoints to file automatically.
keymap("n", "<YourKey1>", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
keymap("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
keymap("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
```

### **:PBToggleBreakpoint** 
Like `:lua require('dap').toggle_breakpoint()`
### **:PBSetConditionalBreakpoint** 
Like `:lua require('dap').set_breakpoint(vim.fn.input('[Condition] > '))`
### **:PBClearAllBreakpoints** 
Like `:lua require('dap').clear_breakpoints()`


## Issue
* Unlike Vscode, persistent breakpoints will only be set when the corresponding file is loaded info buffer. But it can save the breakpoints properly even if a buffer with breakpoints have been closed.
* Like Vscode, if your pwd is `/a/b/` and you add breakpoints to file `/a/b/c.xx`, file `/a/b/c.xx`'s breakpoints are not loaded when your pwd is not `/a/b/`.   
Therefore, a session manager plugin is recommended. 

## Other
PR and ISSUE are welcome:
* Performance improvements.
* Bug fix
* Useful and necessary features.

