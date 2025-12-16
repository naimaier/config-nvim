local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '

local keymap = vim.keymap

keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Navigate vim panes better
keymap.set('n', '<c-k>', ':wincmd k<CR>')
keymap.set('n', '<c-j>', ':wincmd j<CR>')
keymap.set('n', '<c-h>', ':wincmd h<CR>')
keymap.set('n', '<c-l>', ':wincmd l<CR>')

keymap.set('n', '<leader>h', ':nohlsearch<CR>')
