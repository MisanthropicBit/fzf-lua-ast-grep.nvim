local plugin_dir = vim.fn.stdpath("data") .. "/lazy"

vim.opt.rtp:append(".")
vim.opt.rtp:append(plugin_dir .. "/fzf-lua")
vim.opt.rtp:append(plugin_dir .. "/plenary.nvim")
vim.cmd.runtime({ "plugin/plenary.vim", bang = true })
