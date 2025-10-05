-- shift code --
vim.keymap.set('x', '>', ">gv", { desc = "Shift code right" })
vim.keymap.set('x', '<', "<gv", { desc = "Shift code left" })

-- lsp --
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code action" })

vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = "Code format" })

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation" })

vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = "Rename symbol" })
