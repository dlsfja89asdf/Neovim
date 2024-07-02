require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del
local telescope_builtin = require "telescope.builtin"

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-p>", telescope_builtin.find_files, {})
unmap("n", "<C-c>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Telescope lsp
vim.keymap.set("n", "<leader>sr", "<cmd>Telescope lsp_references<CR>", { desc = "Search symbol references" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Search symbol definitions" })
vim.keymap.set("n", "<leader>si", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Search incoming calls" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "Search outgoing calls" })
vim.keymap.set("n", "<leader>sI", "<cmd>Telescope lsp_implementations<CR>", { desc = "Search implementations" })
vim.keymap.set("n", "<leader>sS", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Search document symbols" })
vim.keymap.set("n", "<leader>st", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Search type definitions" })
vim.keymap.set(
  "n",
  "<leader>ss",
  "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
  { desc = "Search dynamic workspace symbols" }
)

-- Telescope git
vim.keymap.set("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })

-- frecency
vim.keymap.del("n", "<C-p>")
vim.keymap.set("n", "<C-p>", function()
  require("telescope").extensions.frecency.frecency {
    workspace = "CWD",
  }
end)

-- vim-visual-multi Remove conflicting mappings
vim.g.VM_leader = " "
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["I BS"] = "",
  ["Visual All"] = "",
  ["Select All"] = "",
}

-- custom commands
vim.api.nvim_create_user_command("CpPath", function()
  local path = vim.fn.expand("%:p"):gsub("\\", "/")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CpRelPath", function()
  local path = vim.fn.fnamemodify(vim.fn.expand "%", ":."):gsub("\\", "/")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("ClearTempShada", function()
  os.execute 'powershell /c "Remove-Item C:\\Users\\GH21140\\AppData\\Local\\nvim-data\\shada\\main.shada.tmp.*"'
end, {})

vim.api.nvim_create_user_command("HideVirtualText", function()
  vim.diagnostic.config { virtual_text = false }
end, {})

vim.api.nvim_create_user_command("ShowVirtualText", function()
  vim.diagnostic.config { virtual_text = true }
end, {})

vim.api.nvim_create_user_command("Edit", function(opts)
  local path = vim.fn.expand(opts.fargs[1]:gsub('"', "")):gsub("\\", "/")
  vim.cmd("e " .. path)
end, { nargs = 1 })

vim.keymap.del("n", "<leader>e")
vim.keymap.set("n", "<leader>e", function()
  vim.cmd.Edit(vim.fn.getreg('+'))
end, { desc = "Open file from clipboard" })
