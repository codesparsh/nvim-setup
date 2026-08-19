return {

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufWritePost", "InsertLeave" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim", "mason.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },

    -- File navigation and management
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },

    -- Undo history visualization
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },

    -- TODO comments highlighting
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                signs = true,
                keywords = {
                    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
            })
        end,
    },

    -- Diagnostics viewer
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                auto_fold = false,
            })
        end,
    },

    -- Merged with NvChad's cmp-bundled autopairs; only add treesitter-aware opts
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
            ts_config = {
                lua = { "string", "source" },
                javascript = { "string", "template_string" },
                java = false,
            },
            disable_filetype = { "TelescopePrompt", "vim" },
        },
    },

    -- Better commenting
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = "^$",
                toggler = {
                    line = "gcc",
                    block = "gbc",
                },
                opleader = {
                    line = "gc",
                    block = "gb",
                },
                extra = {
                    above = "gcO",
                    below = "gco",
                    eol = "gcA",
                },
            })
        end,
    },

    -- Git signs in the gutter + inline diff highlights
    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signs_staged = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "~" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                diff_opts = {
                    internal = true,
                    indent_heuristic = true,
                },
                watch_gitdir = {
                    interval = 2000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 500,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                sign_priority = 6,
                update_debounce = 250,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "rounded",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
        end,
    },

    -- Side-by-side and file-history diffs
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = "diff2_horizontal",
                    },
                    merge_tool = {
                        layout = "diff3_horizontal",
                    },
                },
                file_panel = {
                    listing_style = "tree",
                },
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "│",
                    tab_char = "│",
                },
                whitespace = {
                    remove_blankline_trail = false,
                },
                scope = {
                    enabled = false,
                },
            })
        end,
    },

    -- Better folding
    {
        "kevinhwang91/nvim-ufo",
        event = "User FilePost",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    if vim.b[bufnr].large_buf or vim.api.nvim_buf_line_count(bufnr) > 5000 then
                        return { "indent" }
                    end
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    -- Better terminal integration
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "TermExec" },
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = "float",
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background = "Normal",
                    },
                },
            })
        end,
    },

    -- Better search and replace
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- VS Code-style multi-cursor (Cmd+D, Cmd+Shift+L, Cmd+U)
    {
        "mg979/vim-visual-multi",
        event = "VeryLazy",
        init = function()
            vim.g.VM_maps = {
                ["Find Under"] = "<D-d>",
                ["Find Subword Under"] = "<D-d>",
                ["Select All"] = "<S-D-l>",
                ["Visual All"] = "<S-D-l>",
                ["Remove Last Region"] = "<D-u>",
            }
        end,
    },

    -- Session management
    {
        "rmagatti/auto-session",
        cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            })
        end,
    },

    -- Haskell-specific plugins
    {
        "mrcjkb/haskell-tools.nvim",
        version = "^3",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        -- Must run at startup, before haskell-tools.nvim reads vim.g.haskell_tools
        init = function()
            vim.g.haskell_tools = require("configs.haskell").haskell_tools()
        end,
    },
}
