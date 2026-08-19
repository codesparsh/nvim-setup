local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Suppress deprecation warning for lspconfig (needed for mason-lspconfig compatibility)
-- This warning will be resolved when NvChad migrates to vim.lsp.config API
-- The warning is printed via vim.deprecate, so we intercept it
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
    if name == "lspconfig" or (type(name) == "string" and name:match("lspconfig")) then
        return -- Suppress lspconfig deprecation warnings
    end
    return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- Note: require('lspconfig') is deprecated but still needed for NvChad compatibility
-- This warning will be resolved when NvChad migrates to vim.lsp.config API
local lspconfig = require("lspconfig")

-- Restore original deprecate function after loading
vim.deprecate = original_deprecate

-- list of all servers configured
lspconfig.servers = {
    "lua_ls",
    "ts_ls", -- TypeScript/JavaScript
    -- "hls", -- Handled by haskell-tools.nvim
}

-- list of servers configured with default config.
local default_servers = {
    -- "ols",
    -- "pyright",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

-- Haskell Language Server is configured via haskell-tools.nvim plugin
-- This provides better integration with Hoogle, repl, etc.
-- Commented out to avoid conflicts with haskell-tools.nvim
-- lspconfig.hls.setup({
--     on_attach = function(client, bufnr)
--         -- Disable formatting - we use fourmolu instead
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--         on_attach(client, bufnr)
--     end,
--     on_init = on_init,
--     capabilities = capabilities,
--     cmd = { "haskell-language-server-wrapper", "--lsp" },
--     filetypes = { "haskell", "lhaskell" },
--     root_dir = lspconfig.util.root_pattern(
--         "*.cabal",
--         "stack.yaml",
--         "cabal.project",
--         "package.yaml",
--         "hie.yaml",
--         ".git"
--     ),
--     settings = {
--         haskell = {
--             -- Use the project's cabal build system
--             cabalFormattingProvider = "none", -- Use fourmolu instead
--             formattingProvider = "none", -- Use fourmolu instead
--             -- Enable HLS features
--             checkParents = "CheckOnSave",
--             checkProject = true,
--             maxCompletions = 40,
--             -- Plugin settings
--             plugin = {
--                 ["ghcide-type-lenses"] = {
--                     globalOn = false,
--                     perFileOn = true,
--                 },
--                 ["ghcide-hover-and-symbols"] = {
--                     hoverOn = true,
--                 },
--                 ["ghcide-code-actions"] = {
--                     codeActionsOn = true,
--                 },
--                 ["ghcide-completions"] = {
--                     autoExtendOn = true,
--                 },
--             },
--         },
--     },
-- })

-- TypeScript/JavaScript Language Server
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- Disable formatting - we use prettier/eslint instead
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "tsx" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
            },
        },
    },
})

-- Lua Language Server
-- Note: Using lspconfig.setup() for compatibility with NvChad
-- The deprecation warning is expected until nvim-lspconfig v3.0.0
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 5000,
                preloadFileSize = 1000,
            },
        },
    },
})
