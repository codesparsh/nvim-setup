local ts_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "tsx",
}

local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        haskell = { "fourmolu" },
        -- TypeScript / JavaScript (Prettier)
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        tsx = { "prettier" },
        json = { "prettier" },
        -- c = { "clang-format" },
        -- cpp = { "clang-format" },
        -- go = { "gofumpt", "goimports-reviser", "golines" },
        -- python = { "isort", "black" },
    },

    formatters = {
        -- Haskell (fourmolu)
        fourmolu = {
            prepend_args = {
                "--stdin-input-file",
                "$FILENAME",
            },
            find_config_file = function(ctx)
                -- Look for fourmolu.yaml in project root
                local util = require("conform.util")
                return util.find_file(ctx.filename, "fourmolu.yaml")
            end,
        },
        -- -- C & C++
        -- ["clang-format"] = {
        --     prepend_args = {
        --         "-style={ \
        --                 IndentWidth: 4, \
        --                 TabWidth: 4, \
        --                 UseTab: Never, \
        --                 AccessModifierOffset: 0, \
        --                 IndentAccessModifiers: true, \
        --                 PackConstructorInitializers: Never}",
        --     },
        -- },
        -- -- Golang
        -- ["goimports-reviser"] = {
        --     prepend_args = { "-rm-unused" },
        -- },
        -- golines = {
        --     prepend_args = { "--max-len=80" },
        -- },
        -- -- Lua
        -- stylua = {
        --     prepend_args = {
        --         "--column-width", "80",
        --         "--line-endings", "Unix",
        --         "--indent-type", "Spaces",
        --         "--indent-width", "4",
        --         "--quote-style", "AutoPreferDouble",
        --     },
        -- },
        -- JavaScript/TypeScript (prettier)
        prettier = {
            prepend_args = {
                "--stdin-filepath",
                "$FILENAME",
            },
            find_config_file = function(ctx)
                -- Look for prettier config files in project root
                local util = require("conform.util")
                return util.find_file(ctx.filename, {
                    ".prettierrc",
                    ".prettierrc.json",
                    ".prettierrc.js",
                    ".prettierrc.cjs",
                    ".prettierrc.mjs",
                    "prettier.config.js",
                    "prettier.config.cjs",
                    "prettier.config.mjs",
                    ".prettierrc.yaml",
                    ".prettierrc.yml",
                    "package.json",
                })
            end,
        },
        -- -- Python
        -- black = {
        --     prepend_args = {
        --         "--fast",
        --         "--line-length",
        --         "80",
        --     },
        -- },
        -- isort = {
        --     prepend_args = {
        --         "--profile",
        --         "black",
        --     },
        -- },
    },

    format_on_save = function(bufnr)
        if vim.g.disable_format_on_save then
            return nil
        end

        local ft = vim.bo[bufnr].filetype
        for _, ts_ft in ipairs(ts_filetypes) do
            if ft == ts_ft then
                return {
                    timeout_ms = 1000,
                    lsp_fallback = true,
                }
            end
        end

        return {
            timeout_ms = 500,
            lsp_fallback = true,
        }
    end,
}

require("conform").setup(options)
