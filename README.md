# Persistent checkpoints 
persistent-breakpoints is a lua plugin for Neovim to save the [nvim-dap](https://github.com/mfussenegger/nvim-dap)'s checkpoints to file and automatically load them when you open neovim. It is based on the code in [here](https://github.com/mfussenegger/nvim-dap/issues/198), but has better performance and some bugs are fixed.

:star: Your stars are my biggest motivation.

## Install
With packer.nvim  
```lua
use {
	'Weissle/persistent-breakpoints.nvim',
	requires = 'mfussenegger/nvim-dap',
	config = function ()
		require('persistent-breakpoints').setup{}
	end
}
```

## Usage
```lua
-- automatically load breakpoints when a file is loaded into the buffer.
vim.api.nvim_create_autocmd({"BufReadPost"},{ callback = require('persistent-breakpoints.api').load_breakpoints })

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- Save breakpoints to file automatically.
keymap("n", "<YourKey1>", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint<cr>", opts)
keymap("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
keymap("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
```

### **:PBToggleBreakpoint** 
Like require('dap').toggle_breakpoint()
### **:PBSetConditionalBreakpoint** 
Like require('dap').set_breakpoint()
### **:PBClearAllBreakpoints** 
Like require('dap').clear_breakpoints()


## Issue
* Unlike Vscode, persistent breakpoints will only be set when the corresponding file is loaded info buffer. But it can save the breakpoints properly even if a buffer with breakpoints have been closed.
* Like Vscode, if your pwd is `/a/b/` and you add breakpoints to file `/a/b/c.xx`, file `/a/b/c.xx`'s breakpoints are not loaded when your pwd is not `/a/b/`.   
Therefore, a session manager plugin is recommended. 

## Other
PR and ISSUE are welcome:
* Performance improvements.
* Bug fix
* Useful and necessary features.

