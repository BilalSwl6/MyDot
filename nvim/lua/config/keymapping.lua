vim.g.mapleader = " "
vim.g.maplocalleader = "/"

-- nvim-tree
vim.api.nvim_set_keymap('n', '<leader>ee', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tc', function()
  require('nvim-tree.api').tree.collapse_all()
end, { desc = "Fold all folders in Nvim Tree" })

-- make tabs easier to navigatete
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tx', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<CR>', { noremap = true, silent = true })


-- telescope
vim.api.nvim_set_keymap('n', '<leader>fa', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope git_files<CR>', { noremap = true, silent = true })

-- Toggleterm
vim.api.nvim_set_keymap('n', '<leader>t1', ':ToggleTerm1<CR>', { noremap = true, silent = true, desc = "Toggle Terminal 1" })
vim.api.nvim_set_keymap('n', '<leader>t2', ':ToggleTerm2<CR>', { noremap = true, silent = true, desc = "Toggle Terminal 2" })
vim.api.nvim_set_keymap('n', '<leader>t3', ':ToggleTerm3<CR>', { noremap = true, silent = true, desc = "Toggle Terminal 3" })
vim.api.nvim_set_keymap('n', '<leader>t4', ':ToggleTerm4<CR>', { noremap = true, silent = true, desc = "Toggle Terminal 4" })
