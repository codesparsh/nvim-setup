-- Slack Dark Mode inspired theme for NvChad (base46)
-- Warm charcoal backgrounds, muted accents, subtle contrast.

local M = {}

M.base_30 = {
  white = "#E8E8E8",
  darker_black = "#121418",
  black = "#1A1D21", -- main editor bg
  black2 = "#222529", -- sidebar / elevated surface
  one_bg = "#2C2D30", -- hover / active
  one_bg2 = "#38393B", -- selection / borders
  one_bg3 = "#3F4145",
  grey = "#565856",
  grey_fg = "#6B6C70",
  grey_fg2 = "#7A7B7E",
  light_grey = "#9A9B9E",
  red = "#E01E5A",
  baby_pink = "#E8A0B4",
  pink = "#D4A0C8",
  line = "#38393B",
  green = "#2BAC76",
  vibrant_green = "#4CC38A",
  blue = "#1D9BD1",
  nord_blue = "#36C5F0",
  yellow = "#ECB22E",
  sun = "#F0C14B",
  purple = "#9B6B9E",
  dark_purple = "#7C4A7F",
  teal = "#4A9B9F",
  orange = "#E8912D",
  cyan = "#5FB5D4",
  statusline_bg = "#222529",
  lightbg = "#2C2D30",
  pmenu_bg = "#1D9BD1",
  folder_bg = "#1D9BD1",
}

M.base_16 = {
  base00 = "#1A1D21",
  base01 = "#222529",
  base02 = "#2C2D30",
  base03 = "#38393B",
  base04 = "#6B6C70",
  base05 = "#D1D2D3",
  base06 = "#E8E8E8",
  base07 = "#F8F8F8",
  base08 = "#E01E5A",
  base09 = "#ECB22E",
  base0A = "#E8912D",
  base0B = "#2BAC76",
  base0C = "#5FB5D4",
  base0D = "#1D9BD1",
  base0E = "#C9A0DC",
  base0F = "#9B6B9E",
}

M.type = "dark"

M.polish_hl = {
  defaults = {
    Comment = { fg = "#9A9B9E", italic = true },
    LineNr = { fg = "#6B6C70" },
    CursorLineNr = { fg = "#1D9BD1", bold = true },
    Visual = { bg = "#38393B" },
    Cursor = { fg = "#1A1D21", bg = "#E8E8E8" },
    iCursor = { fg = "#1A1D21", bg = "#E8E8E8" },
    nCursor = { fg = "#1A1D21", bg = "#E8E8E8" },
    vCursor = { fg = "#1A1D21", bg = "#E8E8E8" },
    TermCursor = { fg = "#1A1D21", bg = "#E8E8E8" },
    TermCursorNC = { fg = "#1A1D21", bg = "#6B6C70" },
    CursorLine = { bg = "#222529" },
    SignColumn = { bg = "#1A1D21" },
    NormalFloat = { bg = "#222529" },
    FloatBorder = { fg = "#565856" },
    Pmenu = { bg = "#222529" },
    PmenuSel = { bg = "#2C2D30", fg = "#E8E8E8" },
    Search = { bg = "#38393B", fg = "#E8E8E8" },
    IncSearch = { bg = "#1D9BD1", fg = "#1A1D21" },
    MatchParen = { bg = "#38393B", bold = true },
    VertSplit = { fg = "#38393B" },
    WinSeparator = { fg = "#38393B" },
    TabLine = { bg = "#1A1D21", fg = "#9A9B9E" },
    TabLineFill = { bg = "#1A1D21" },
    TabLineSel = { bg = "#222529", fg = "#E8E8E8" },
    StatusLine = { bg = "#222529", fg = "#9A9B9E" },
    StatusLineNC = { bg = "#1A1D21", fg = "#6B6C70" },
  },
}

M = require("base46").override_theme(M, "slack_dark")

return M
