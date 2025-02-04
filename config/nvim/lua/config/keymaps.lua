-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local map = vim.keymap.set
-- local unmap = vim.keymap.del

-- Unmap Ctrl-[hjkl] in terminal mode
-- unmap("t", "<C-h>")
-- unmap("t", "<C-j>")
-- unmap("t", "<C-k>")
-- unmap("t", "<C-l>")
map("i", "<M-`>", "<Esc>")
-- map("n", "<F1>", "<Esc>")
-- map("v", "<F1>", "<Esc>")
-- map("i", "<F1>", "<Esc>")
map("n", "<F2>", "i")
map("v", "<F2>", "i")
map("i", "<F2>", "")

-- Forward / Backward word
map("n", "<C-Right>", "W")
map("v", "<C-Right>", "W")
map("i", "<C-Right>", "<S-Right>")
map("n", "<C-Left>", "B")
map("v", "<C-Left>", "B")
map("i", "<C-Left>", "<S-Left>")

-- Jump paragraph
map("n", "<C-Up>", "{")
map("v", "<C-Up>", "{")
map("n", "<C-Down>", "}")
map("v", "<C-Down>", "}")

-- Make some Ctrl keys in insert mode Emacs-like
map("i", "<C-a>", "<C-o>^")
map("i", "<C-e>", "<End>")
map("i", "<C-d>", "<Del>")
-- map("i", "<C-h>", "<BS>")
map("i", "<C-b>", "<Left>")
map("i", "<C-f>", "<Right>")
map("i", "<C-p>", "<Up>")
map("i", "<C-n>", "<Down>")
map("i", "<M-d>", "<C-o>dw")
map("i", "<M-b>", "<S-Left>")
map("i", "<M-f>", "<S-Right>")
map("i", "<C-u>", "<C-o>^<C-o>d$", { noremap = true, silent = true })
map("i", "<C-y>", "<C-o>p", { noremap = true, silent = true })
map('i', '<C-w>', function()
  return vim.fn.col('.') > 1 and
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-o>db', true, false, true), 'n', true) or ''
end, { expr = true })

map('i', '<M-w>', function()
  local col = vim.fn.col('.')
  if col == 1 then return '' end

  local line = vim.fn.getline('.')
  local before_cursor = line:sub(1, col - 1)

  local last_boundary = before_cursor:find('%s[^%s]+%s*$') or 0
  local delete_length = col - last_boundary - 1

  return vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(
      '<C-\\><C-o>' .. delete_length .. 'X',
      true,
      false,
      true
    ),
    'n',
    true
  )
end, { expr = true })

-- Undo
map("i", "<C-/>", "<C-o>u", { noremap = true, silent = true })
map("i", "<C-_>", "<C-o>u", { noremap = true, silent = true })
-- Redo
map("i", "<C-r>", "<C-o><C-r>", { noremap = true, silent = true })

-- Override Ctrl-k (LSP Signature Help)
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		vim.api.nvim_buf_set_keymap(args.buf, "i", "<C-k>", "<C-o>d$", { noremap = true, silent = true })
-- 	end,
-- })

-- Add border to Terminal
local snackterm = function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end

-- Start Terminal keymap
map("n", "<leader>tt", snackterm, { desc = "Terminal (root dir)" })
map("n", "<C-/>", snackterm, { desc = "Terminal (root dir)" })
map("n", "<C-_>", snackterm, { desc = "which_key_ignore" })
