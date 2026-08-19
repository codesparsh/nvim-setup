local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    haskell = { "hlint" },
    -- JavaScript/TypeScript linting disabled (install eslint to enable)
    -- javascript = { "eslint" },
    -- javascriptreact = { "eslint" },
    -- typescript = { "eslint" },
    -- typescriptreact = { "eslint" },
    -- python = { "flake8" },
}

lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

lint.linters.hlint.args = {
    "--json",
    "-",
}

-- ESLint configuration (will use project's eslint if available)
-- No custom args needed - it will auto-detect config

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
        if vim.b.large_buf then
            return
        end
        lint.try_lint()
    end,
})
