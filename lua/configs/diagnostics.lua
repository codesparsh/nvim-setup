local M = {}

local function max_float_width()
  return math.max(40, math.floor(vim.o.columns * 0.9))
end

local function max_float_height()
  return math.max(10, math.floor(vim.o.lines * 0.9))
end

local function truncate_display(text, max_width)
    text = text:gsub("\n%s*", " "):gsub("%s+", " ")
    if vim.fn.strdisplaywidth(text) <= max_width then
        return text
    end

    local lo, hi = 0, #text
    while lo < hi do
        local mid = math.floor((lo + hi + 1) / 2)
        local slice = text:sub(1, mid)
        if vim.fn.strdisplaywidth(slice .. "...") <= max_width then
            lo = mid
        else
            hi = mid - 1
        end
    end

    return lo > 0 and text:sub(1, lo) .. "..." or "..."
end

local function inline_max_width()
    -- Right-aligned virtual text: reserve gutter + padding
    local win_width = vim.api.nvim_win_get_width(0)
    local sign_col = vim.wo.signcolumn == "yes" and 2 or 0
    return math.max(20, math.floor((win_width - sign_col - 4) * 0.45))
end

local function apply_diagnostic_config()
    local x = vim.diagnostic.severity

    vim.diagnostic.config({
        virtual_text = {
            prefix = "",
            spacing = 1,
            source = "if_many",
            virt_text_pos = "eol_right_align",
            current_line_only = true,
            format = function(diagnostic)
                local icon = ({
                    [x.ERROR] = "󰅙 ",
                    [x.WARN] = " ",
                    [x.INFO] = "󰋼 ",
                    [x.HINT] = "󰌵 ",
                })[diagnostic.severity] or ""
                return icon .. truncate_display(diagnostic.message, inline_max_width())
            end,
        },
        signs = {
            text = {
                [x.ERROR] = "󰅙",
                [x.WARN] = "",
                [x.INFO] = "󰋼",
                [x.HINT] = "󰌵",
            },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            wrap = true,
            focusable = true,
            focus = true,
            max_width = max_float_width,
            max_height = max_float_height,
            format = function(diagnostic)
                return vim.split(diagnostic.message, "\n", { plain = true, trimempty = false })
            end,
        },
    })
end

function M.open_float()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

    if #diagnostics == 0 then
        diagnostics = vim.diagnostic.get(0, { cursor = true })
    end

    if #diagnostics == 0 then
        vim.notify("No diagnostics at cursor", vim.log.levels.INFO)
        return
    end

    vim.diagnostic.sort(diagnostics)

    local lines = {}
    for i, diagnostic in ipairs(diagnostics) do
        if i > 1 then
            lines[#lines + 1] = ""
            lines[#lines + 1] = string.rep("─", math.min(60, max_float_width() - 4))
            lines[#lines + 1] = ""
        end

        local severity = vim.diagnostic.severity[diagnostic.severity] or "DIAGNOSTIC"
        local header = string.format("[%s]", severity)
        if diagnostic.source then
            header = header .. " " .. diagnostic.source
        end
        if diagnostic.code then
            header = header .. string.format(" (%s)", diagnostic.code)
        end
        lines[#lines + 1] = header

        for _, line in ipairs(vim.split(diagnostic.message, "\n", { plain = true, trimempty = false })) do
            lines[#lines + 1] = line
        end
    end

    vim.lsp.util.open_floating_preview(lines, "plaintext", {
        border = "rounded",
        max_width = max_float_width(),
        max_height = max_float_height(),
        focusable = true,
        focus = true,
    })
end

function M.setup()
    -- Always reapply: NvChad calls its own diagnostic_config after us on LSP load
    apply_diagnostic_config()

    if M._autocmds then
        return
    end
    M._autocmds = true

    local group = vim.api.nvim_create_augroup("DiagnosticsConfig", { clear = true })

    local border = "rounded"
    local hover_opts = {
        border = border,
        max_width = max_float_width(),
        max_height = max_float_height(),
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_opts)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
        max_width = max_float_width(),
        max_height = max_float_height(),
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function()
            apply_diagnostic_config()
        end,
    })

    vim.api.nvim_create_autocmd("VimResized", {
        group = group,
        callback = function()
            apply_diagnostic_config()
            local buf = vim.api.nvim_get_current_buf()
            if vim.api.nvim_buf_is_loaded(buf) then
                vim.diagnostic.show(nil, nil, buf)
            end
        end,
    })
end

return M
