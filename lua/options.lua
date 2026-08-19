require("nvchad.options")

local o = vim.o
local wo = vim.wo
local g = vim.g

-- Font settings (Cursor uses JetBrains Mono or SF Mono)
-- For GUI Neovim clients (neovide, nvim-qt, etc.)
if vim.g.neovide then
    vim.o.guifont = "JetBrains Mono:h14"
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_size = 0.3
elseif vim.g.fvim_loaded then
    vim.o.guifont = "JetBrains Mono:h14"
end

-- For terminal Neovim, the font is set in your terminal emulator
-- Recommended fonts: JetBrains Mono, SF Mono, Cascadia Code, or Fira Code

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- Better search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- Better editing experience
o.expandtab = true
o.smartindent = true
o.breakindent = true
o.linebreak = true
o.wrap = false

-- Better scrolling
o.scrolloff = 8
o.sidescrolloff = 8
o.scrolljump = 5

-- Better UI
o.number = true
o.relativenumber = false
o.cursorline = true
o.signcolumn = "yes"
o.colorcolumn = "" -- Disabled (was set to "80")
o.showmode = false -- Already handled by statusline
o.showcmd = true
o.cmdheight = 1
o.laststatus = 3
-- showtabline is managed by NvChad tabufline

-- Better completion
o.completeopt = "menuone,noselect"
o.shortmess = "filnxtToOFc"

-- Better file handling
o.hidden = true
o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath("data") .. "/undo"

-- Better performance
o.updatetime = 300
o.timeoutlen = 300
o.ttimeoutlen = 0
o.lazyredraw = true

-- Better window splitting
o.splitbelow = true
o.splitright = true

-- Better terminal
o.termguicolors = true

-- Better folding (handled by nvim-ufo plugin)
o.foldenable = true

-- Clipboard: cache system clipboard to avoid pbcopy/pbpaste on every keystroke
vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = true,
}
o.clipboard = "unnamedplus"

-- Better mouse support
o.mouse = "a"

-- Treesitter handles highlighting; legacy syntax is slower and redundant
o.syntax = ""

-- Disable expensive features on very large buffers
vim.api.nvim_create_autocmd("BufReadPre", {
    group = vim.api.nvim_create_augroup("PerfLargeFile", { clear = true }),
    callback = function()
        if vim.api.nvim_buf_line_count(0) > 10000 then
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.spell = false
            vim.opt_local.swapfile = false
            vim.b.large_buf = true
        end
    end,
})

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])
