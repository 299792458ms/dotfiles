-- init.lua

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    "sindrets/diffview.nvim",
    {"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }},
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim",}}
})

-- settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.cmd[[colorscheme tokyonight-night]]
vim.filetype.add {
    extension = { rasi = 'rasi' },
    pattern = {
        ['.*/waybar/config'] = 'jsonc',
        ['.*/hypr/.*%.conf'] = 'hyprlang',
        ['.*/.config/sway/.*'] = 'swayconfig',
    },
}

require("diffview").setup()

require("ibl").setup()

-- lualine
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- treesitter
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    indent = { enable = true },
    ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "cpp",
        "hyprlang",
        "kdl",
    }
})

-- folds
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
    pattern = {"*.*"},
    desc = "save view (folds), when closing file",
    command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
    pattern = {"*.*"},
    desc = "load view (folds), when opening file",
    command = "silent! loadview"
})

-- Map
vim.g.mapleader = ';'

