local options = {
    sync_install = false,
    auto_install = false,

    ensure_installed = {
        "bash",
        -- "c",
        -- "cmake",
        -- "cpp",
        "fish",
        -- "go",
        -- "gomod",
        -- "gosum",
        -- "gotmpl",
        -- "gowork",
        "haskell",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        -- "make",
        "markdown",
        -- "odin",
        "printf",
        -- "python",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    indent = { enable = false },
}

require("nvim-treesitter.configs").setup(options)
