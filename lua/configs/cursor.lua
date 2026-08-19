local M = {}

-- VS Code Dark+ style: light cursor on dark background
local cursor_fg = "#1E1E1E"
local cursor_bg = "#AEAFAD"

local cursor_hl = {
    Cursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    nCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    iCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    vCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    oCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    cCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    lCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    TermCursor = { fg = cursor_fg, bg = cursor_bg, reverse = false, bold = true },
    TermCursorNC = { fg = cursor_fg, bg = "#858585", reverse = false, bold = true },
}

local guicursor = {
    "n:block-nCursor",
    "v:block-vCursor",
    "i-ci-ve:ver25-iCursor",
    "c:block-cCursor",
    "r-cr:hor20-Cursor",
    "o:hor50-oCursor",
    "O:block-oCursor",
    "a:blinkon100-blinkoff100",
}

function M.apply()
    for name, hl in pairs(cursor_hl) do
        vim.api.nvim_set_hl(0, name, hl)
    end

    if vim.o.termguicolors then
        vim.opt.guicursor = guicursor
    end

    if vim.g.neovide then
        vim.g.neovide_cursor_color = cursor_bg
        vim.g.neovide_cursor_color_in_insert_mode = cursor_bg
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("LightCursor", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme", "ModeChanged" }, {
        group = group,
        callback = M.apply,
    })

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "NvThemeReload", "LazyDone" },
        callback = function()
            vim.schedule(M.apply)
        end,
    })
end

return M
