local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h')

vim.opt.rtp:prepend(root)
vim.opt.rtp:prepend(root .. '/deps/mini.nvim')

vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site')

require('mini.test').setup()
