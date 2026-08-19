require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Format (TypeScript/JavaScript use Prettier via conform.nvim)
local function format_buffer()
    require("conform").format({
        lsp_fallback = true,
        timeout_ms = 1000,
    })
end

map({ "n", "v" }, "<leader>fm", format_buffer, { desc = "Format buffer / selection" })
map("n", "<leader>fM", function()
    vim.g.disable_format_on_save = not vim.g.disable_format_on_save
    local state = vim.g.disable_format_on_save and "off" or "on"
    vim.notify("Format on save: " .. state)
end, { desc = "Toggle format on save" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Harpoon mappings (file navigation)
map("n", "<leader>ha", function()
    require("harpoon"):list():append()
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon quick menu" })

map("n", "<leader>h1", function()
    require("harpoon"):list():select(1)
end, { desc = "Harpoon to file 1" })

map("n", "<leader>h2", function()
    require("harpoon"):list():select(2)
end, { desc = "Harpoon to file 2" })

map("n", "<leader>h3", function()
    require("harpoon"):list():select(3)
end, { desc = "Harpoon to file 3" })

map("n", "<leader>h4", function()
    require("harpoon"):list():select(4)
end, { desc = "Harpoon to file 4" })

-- Undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undotree" })

-- Trouble (diagnostics)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle trouble" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
map("n", "]d", function()
    vim.diagnostic.goto_next()
    require("configs.diagnostics").open_float()
end, { desc = "Next diagnostic" })
map("n", "[d", function()
    vim.diagnostic.goto_prev()
    require("configs.diagnostics").open_float()
end, { desc = "Previous diagnostic" })
map("n", "<leader>cd", function()
    require("configs.diagnostics").open_float()
end, { desc = "Show diagnostic float" })

-- Todo comments
map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo trouble" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo telescope" })

-- ToggleTerm
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle terminal float" })
map("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "Toggle terminal horizontal" })
map("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "Toggle terminal vertical" })

-- Spectre (search and replace)
map("n", "<leader>sp", function()
    require("spectre").open()
end, { desc = "Replace in files (Spectre)" })

-- Auto-session
map("n", "<leader>ss", "<cmd>SaveSession<cr>", { desc = "Save session" })
map("n", "<leader>sR", "<cmd>RestoreSession<cr>", { desc = "Restore session" })

-- Lazy plugin management
map("n", "<leader>lp", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
map("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })

-- Haskell-specific mappings (using <leader>H to avoid conflict with Harpoon)
map("n", "<leader>Hr", function()
    require("haskell-tools").repl.toggle()
end, { desc = "Toggle Haskell REPL" })

map("n", "<leader>Hq", function()
    require("haskell-tools").repl.quit()
end, { desc = "Quit Haskell REPL" })

map("n", "<leader>Hs", function()
    require("haskell-tools").hoogle.hoogle_signature()
end, { desc = "Hoogle signature search" })

map("n", "<leader>Hp", function()
    require("haskell-tools").project.load_project()
end, { desc = "Load Haskell project" })

map("n", "<leader>HR", "<cmd>HlsRestart<cr>", { desc = "Restart Haskell LSP" })

map("n", "<leader>Hc", function()
    require("haskell-tools").cabal.build_project()
end, { desc = "Build Haskell project (Cabal)" })

map("n", "<leader>Ht", function()
    require("haskell-tools").cabal.test_project()
end, { desc = "Test Haskell project" })

-- Git diff highlights (gitsigns + diffview)
local function gitsigns_available()
    return pcall(require, "gitsigns")
end

map("n", "]h", function()
    if vim.wo.diff then
        return "]c"
    end
    if gitsigns_available() then
        require("gitsigns").nav_hunk("next")
    end
end, { expr = true, desc = "Next git hunk" })

map("n", "[h", function()
    if vim.wo.diff then
        return "[c"
    end
    if gitsigns_available() then
        require("gitsigns").nav_hunk("prev")
    end
end, { expr = true, desc = "Previous git hunk" })

map({ "n", "v" }, "<leader>gs", function()
    require("gitsigns").stage_hunk()
end, { desc = "Git stage hunk" })

map({ "n", "v" }, "<leader>gr", function()
    require("gitsigns").reset_hunk()
end, { desc = "Git reset hunk" })

map("n", "<leader>gp", function()
    require("gitsigns").preview_hunk()
end, { desc = "Git preview hunk" })

map("n", "<leader>gb", function()
    require("gitsigns").toggle_current_line_blame()
end, { desc = "Git toggle line blame" })

map("n", "<leader>gS", function()
    require("gitsigns").stage_buffer()
end, { desc = "Git stage entire file" })

map("n", "<leader>gR", function()
    require("gitsigns").reset_buffer()
end, { desc = "Git reset entire file" })

map("n", "<leader>gu", function()
    require("gitsigns").undo_stage_hunk()
end, { desc = "Git undo stage hunk" })

map("n", "<leader>gg", "<cmd>DiffviewOpen<cr>", { desc = "Git diff (all changes)" })
map("n", "<leader>gd", "<cmd>DiffviewOpen HEAD<cr>", { desc = "Git diff vs HEAD" })
map("n", "<leader>gD", "<cmd>DiffviewOpen main<cr>", { desc = "Git diff vs main" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git history for current file" })
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close git diff view" })
