return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/nvim-cmp", -- Autocompletion
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      -- Setup Haskell Language Server
      lspconfig.hls.setup {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
    end
}

