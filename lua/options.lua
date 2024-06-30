require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both'

-- powershell
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_option("shell", "powershell")
vim.api.nvim_set_option("shellxquote", "")
vim.api.nvim_set_option("shellquote", "")
vim.api.nvim_set_option("shellcmdflag", "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding = New-Object Text.UTF8Encoding $false;")

-- tabs
vim.api.nvim_set_option("shiftwidth", 4)
vim.api.nvim_set_option("tabstop", 4)

-- diff ignore whitespace
vim.opt.diffopt:append { 'iwhiteall' }

-- more
vim.api.nvim_set_option("scrolloff", 10)  -- offset from the end of the text
vim.api.nvim_set_option("sidescrolloff", 10)  -- offset from the end of the side of text
vim.api.nvim_set_option("inccommand", "split")  -- live command show
vim.api.nvim_set_option("incsearch", true)  -- live split show
-- vim.api.nvim_set_option("nowrap", true)  -- no text wrapping
vim.opt.ignorecase = true -- search case insensitive
vim.opt.smartcase = true -- search matters if capital letter

-- edgy
---- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"

-- Avoid cluttering the buffer
vim.diagnostic.config({ virtual_text = false })

-- Auto read
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
