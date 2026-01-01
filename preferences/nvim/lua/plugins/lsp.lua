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
        -- Linters
        "eslint-lsp",
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
        ts_ls = {
          -- Enable checkJs for JavaScript diagnostics
          init_options = {
            preferences = {
              includeInlayParameterNameHints = "all",
            },
          },
          settings = {
            javascript = {
              suggestionActions = { enabled = true },
            },
            implicitProjectConfiguration = {
              checkJs = true,
            },
          },
        },
        eslint = {},
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
