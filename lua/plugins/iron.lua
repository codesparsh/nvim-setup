return {
  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      iron.setup {
        config = {
           -- Whether a repl should be discarded or not
          scratch_repl = true,
          repl_definition = {
              haskell = {
                 command = function(meta)
                     local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
                     print(file)
                     vim.notify(file, "info")
                     return { "docker" ,"compose", "run", "--rm", "dev", "sh", "-c", "./scripts/repl.sh" }
                 end
              }
            -- haskell = {
            --   command = function(meta)
            --     local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
            --     -- call `require` in case iron is set up before haskell-tools
            --     return require('haskell-tools').repl.mk_repl_cmd(file)
            --   end,
            -- },
          },
          repl_open_cmd = view.split.vertical.botright(0.4),
        },
        keymaps = {
          toggle_repl = "<leader>hr"
        },
      }
    end,
    ft = { "haskell", "python", "lua", "sh", "zsh" },
  },
}
