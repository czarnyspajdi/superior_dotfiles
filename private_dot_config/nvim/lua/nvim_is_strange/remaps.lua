-- telescope --

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Telescope find git' })

-- lsp --
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code action" })

vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = "Code format" })

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation" })

vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = "Rename symbol" })

-- move shit --
vim.keymap.set('x', '>', ">gv", { desc = "Move code right" })
vim.keymap.set('x', '<', "<gv", { desc = "Move code left" })

-- autosave in markdown--
vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if vim.bo.modified and vim.bo.ft == "markdown" then
            vim.cmd("w");
        end
    end
})
-- other --
vim.keymap.set('n', '<space>', '<Nop>')
