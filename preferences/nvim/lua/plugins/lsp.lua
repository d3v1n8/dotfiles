return {
  -- Mason: ensure LSP servers are installed
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- TypeScript/JavaScript
        "typescript-language-server",
        -- Python
        "pyright",
        -- Kotlin
        "kotlin-language-server",
        -- Java
        "jdtls",
        -- Formatters
        "prettier",
        "stylua",
      },
    },
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
        pyright = {},
        kotlin_language_server = {},
        jdtls = {},
      },
    },
  },
}
