-- Kolorystyka
vim.cmd.colorscheme("minimal")

-- Wygląd
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = false

-- Automatyczne podświetlanie skopiowanej linii po użyciu 'yy'
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Włącz widoczność whitespaces
vim.opt.list = true

-- Tabulatory i wcięcia
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Przewijanie i kursor
vim.opt.scrolloff = 8
vim.o.sidescrolloff = 8
vim.opt.cursorline = true

-- Wyszukiwanie
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- Ogólne ustawienia
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.updatetime = 50

-- Język --
vim.opt.spell = true
vim.opt.spelllang = { 'pl', 'en' }
