return {
  -- Mason: ensure LSP servers are installed
  {
    "mason-org/mason.nvim",
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
        -- HTML/CSS
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        -- JSON
        "json-lsp",
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
        html = {},
        cssls = {},
        emmet_ls = {},
        jsonls = {},
      },
    },
  },
}
