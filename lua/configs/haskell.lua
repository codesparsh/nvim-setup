local M = {}

local ghcup_bin = vim.fn.expand("~/.ghcup/bin")

--- Prefer ghcup Haskell toolchain over Homebrew in Neovim subprocesses.
--- chedr-core (LTS 24.49) needs ghc 9.10.3, hls >= 2.12, cabal 3.12.1.0.
function M.setup_path()
  if vim.fn.isdirectory(ghcup_bin) == 0 then
    return
  end

  local path = vim.env.PATH or ""
  if not path:find(ghcup_bin, 1, true) then
    vim.env.PATH = ghcup_bin .. ":" .. path
  end
end

function M.hls_cmd()
  local wrapper = ghcup_bin .. "/haskell-language-server-wrapper"
  if vim.fn.executable(wrapper) == 1 then
    return { wrapper, "--lsp" }
  end

  -- GHC 9.10.3 / LTS 24.49 (HLS ≥ 2.12)
  local hls_9103 = ghcup_bin .. "/haskell-language-server-9.10.3"
  if vim.fn.executable(hls_9103) == 1 then
    return { hls_9103, "--lsp" }
  end

  return { "haskell-language-server-wrapper", "--lsp" }
end

function M.haskell_tools()
  local on_attach = require("nvchad.configs.lspconfig").on_attach
  local capabilities = require("nvchad.configs.lspconfig").capabilities

  return {
    hls = {
      cmd = M.hls_cmd(),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- NvChad on_init: disable semantic tokens (not supported in hls opts)
        if vim.fn.has("nvim-0.11") == 1 then
          if client:supports_method("textDocument/semanticTokens") then
            client.server_capabilities.semanticTokensProvider = nil
          end
        elseif client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end

        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      settings = {
        haskell = {
          formattingProvider = "none",
          cabalFormattingProvider = "none",
        },
      },
    },
    tools = {
      codeLens = { autoRefresh = true },
      hover = { enable = true },
      definition = { hoogle_signature_fallback = true },
    },
  }
end

return M
