-- List of linters to ignore during install
local ignore_install = {}

-- Helper function to find if value is in table.
local function table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Get linters from lint config (ensure lint is loaded first)
local lint = require("lint")
if not lint or not lint.linters_by_ft then
    -- Fallback to explicit list if lint isn't loaded yet
    require("mason-nvim-lint").setup({
        ensure_installed = { "luacheck", "hlint" },
        automatic_installation = false,
    })
    return
end

-- Build a list of linters to install minus the ignored list.
local all_linters = {}
for _, v in pairs(lint.linters_by_ft) do
    if v and type(v) == "table" then
    for _, linter in ipairs(v) do
            if linter and type(linter) == "string" and not table_contains(ignore_install, linter) then
            table.insert(all_linters, linter)
            end
        end
    end
end

require("mason-nvim-lint").setup({
    ensure_installed = all_linters,
    automatic_installation = false,
})
