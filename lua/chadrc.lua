-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "vscode_dark",
    transparency = false,

    -- hl_add creates new groups; hl_override only patches existing base46 groups
    hl_add = {
        Cursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        nCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        iCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        vCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        oCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        cCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        lCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        TermCursor = { fg = "#1E1E1E", bg = "#AEAFAD", reverse = false, bold = true },
        TermCursorNC = { fg = "#1E1E1E", bg = "#858585", reverse = false, bold = true },
    },

    hl_override = {
        Comment = { italic = true, fg = "#6A9955" },
        ["@comment"] = { italic = true, fg = "#6A9955" },
        Normal = { bg = "#1E1E1E", fg = "#D4D4D4" },
        NormalFloat = { bg = "#252526" },
        CursorLine = { bg = "#2A2D2E" },
        Visual = { bg = "#264F78" },
        LineNr = { fg = "#858585" },
        CursorLineNr = { fg = "#C6C6C6", bold = true },
        SignColumn = { bg = "#1E1E1E" },
        FloatBorder = { fg = "#454545" },
        StatusLine = { bg = "#007ACC", fg = "#FFFFFF" },
        StatusLineNC = { bg = "#1E1E1E", fg = "#858585" },
        TabLine = { bg = "#2D2D2D", fg = "#969696" },
        TabLineFill = { bg = "#252526" },
        TabLineSel = { bg = "#1E1E1E", fg = "#FFFFFF" },
        Pmenu = { bg = "#252526" },
        PmenuSel = { bg = "#04395E", fg = "#FFFFFF" },
        Search = { bg = "#515C6A", fg = "#D4D4D4" },
        IncSearch = { bg = "#515C6A", fg = "#FFFFFF" },
        MatchParen = { bg = "#094771", bold = true },
        VertSplit = { fg = "#3C3C3C" },
        WinSeparator = { fg = "#3C3C3C" },

        -- Git gutter signs (VS Code Dark+)
        GitSignsAdd = { fg = "#587C0C" },
        GitSignsChange = { fg = "#0C7D9D" },
        GitSignsDelete = { fg = "#94151B" },
        GitSignsUntracked = { fg = "#73C991" },
        GitSignsAddNr = { fg = "#858585" },
        GitSignsChangeNr = { fg = "#858585" },
        GitSignsDeleteNr = { fg = "#858585" },
        GitSignsUntrackedNr = { fg = "#858585" },

        -- Word-level diff only: faint inline tint, not whole lines
        GitSignsAddLn = { bg = "NONE" },
        GitSignsChangeLn = { bg = "NONE" },
        GitSignsDeleteLn = { bg = "NONE" },
        GitSignsUntrackedLn = { bg = "NONE" },
        GitSignsAddLnInline = { bg = "#2D4A2D", fg = "#B5CEA8" },
        GitSignsChangeLnInline = { bg = "#1E3A44", fg = "#DCDCAA" },
        GitSignsDeleteLnInline = { bg = "#4A2D2D", fg = "#F48771" },

        -- Diffview side-by-side
        DiffAdd = { bg = "#2D4A2D", fg = "#B5CEA8" },
        DiffChange = { bg = "#1E3A44", fg = "#DCDCAA" },
        DiffDelete = { bg = "#4A2D2D", fg = "#F48771" },
        DiffText = { bg = "#264F78", fg = "#D4D4D4" },
    },
}

M.ui = {
    statusline = {
        theme = "default",
        separator_style = "default",
    },
    -- Buffer tabs only (drop Vim tab-page tabs from tabufline)
    tabufline = {
        enabled = true,
        lazyload = true,
        order = { "treeOffset", "buffers", "btns" },
    },
}

return M
