vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- ghcup before Homebrew: chedr-core needs ghc/cabal/hls from ~/.ghcup
require("configs.haskell").setup_path()

-- Suppress lspconfig deprecation warning (needed for NvChad compatibility)
-- This warning will be resolved when NvChad migrates to vim.lsp.config API
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
    if name == "lspconfig" or (type(name) == "string" and name:match("lspconfig")) then
        return -- Suppress lspconfig deprecation warnings
    end
    return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
        config = function()
            require("options")
        end,
    },

    { import = "plugins" },
}, lazy_config)

vim.keymap.set("n", "<Leader>r", function()
    local replacement = vim.fn.input("Replace with : ")
    -- Validate the input
    if replacement ~= "" then
        vim.cmd(":%s//" .. replacement .. "/g")
    else
        print("No replacement provided")
    end
end, { noremap = true, silent = true })

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("configs.cursor").setup()
require("configs.cursor").apply()

require("nvchad.autocmds")

vim.schedule(function()
    require("mappings")
    require("configs.cursor").apply()
end)

-- Defer LSP handler wiring until after startup (saves ~3ms on launch)
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(function()
            require("configs.diagnostics").setup()
        end)
    end,
})

-- Helper function to reset plugins with local changes
vim.api.nvim_create_user_command("LazyResetPlugin", function(opts)
    local plugin_name = opts.args
    if plugin_name == "" then
        vim.notify("Usage: LazyResetPlugin <plugin-name>", vim.log.levels.WARN)
        return
    end

    local lazy_path = vim.fn.stdpath("data") .. "/lazy"
    local plugin_path = lazy_path .. "/" .. plugin_name

    -- Use shell command to forcefully remove the directory
    local cmd = string.format('rm -rf "%s"', plugin_path)
    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
        vim.notify("Removed plugin: " .. plugin_name .. ". Run :Lazy sync to reinstall.", vim.log.levels.INFO)
    else
        vim.notify("Failed to remove plugin: " .. plugin_name .. ". Error: " .. result, vim.log.levels.ERROR)
    end
end, {
    nargs = 1,
    complete = function()
        local lazy_path = vim.fn.stdpath("data") .. "/lazy"
        local plugins = {}
        local handle = vim.loop.fs_scandir(lazy_path)
        if handle then
            while true do
                local name, _ = vim.loop.fs_scandir_next(handle)
                if not name then
                    break
                end
                if name ~= "lazy.nvim" then
                    table.insert(plugins, name)
                end
            end
        end
        return plugins
    end,
})

-- Command to reset all plugins with local changes using git (handles submodules)
vim.api.nvim_create_user_command("LazyResetAll", function()
    local lazy_path = vim.fn.stdpath("data") .. "/lazy"
    local cmd = string.format(
        'cd "%s" && for dir in */; do '
            .. '  if [ -d "$dir/.git" ]; then '
            .. '    cd "$dir" && '
            .. "    git submodule deinit -f . 2>/dev/null; "
            .. "    git reset --hard HEAD && "
            .. "    git clean -fd && "
            .. "    git submodule update --init --recursive 2>/dev/null; "
            .. "    cd ..; "
            .. "  fi; "
            .. "done",
        lazy_path
    )
    vim.notify("Resetting all plugins with local changes (including submodules)...", vim.log.levels.INFO)
    vim.fn.system(cmd)
    vim.notify("Done! Run :Lazy sync to update plugins.", vim.log.levels.INFO)
end, {})

-- Command to fix submodule issues for a specific plugin
vim.api.nvim_create_user_command("LazyFixSubmodules", function(opts)
    local plugin_name = opts.args
    if plugin_name == "" then
        vim.notify("Usage: LazyFixSubmodules <plugin-name>", vim.log.levels.WARN)
        return
    end

    local lazy_path = vim.fn.stdpath("data") .. "/lazy"
    local plugin_path = lazy_path .. "/" .. plugin_name

    if vim.fn.isdirectory(plugin_path) == 0 then
        vim.notify("Plugin not found: " .. plugin_name, vim.log.levels.ERROR)
        return
    end

    local cmd = string.format(
        'cd "%s" && git submodule deinit -f . 2>/dev/null && git submodule update --init --recursive 2>&1',
        plugin_path
    )
    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
        vim.notify("Fixed submodules for: " .. plugin_name, vim.log.levels.INFO)
    else
        vim.notify("Failed to fix submodules. Removing plugin for reinstall: " .. plugin_name, vim.log.levels.WARN)
        vim.fn.system(string.format('rm -rf "%s"', plugin_path))
        vim.notify("Removed. Run :Lazy sync to reinstall.", vim.log.levels.INFO)
    end
end, { nargs = 1 })

