-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { 'williamboman/mason-lspconfig.nvim' },

    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function ()
    require('mason').setup()
    require('mason-lspconfig').setup({
      -- Install these LSPs automatically
      ensure_installed = {
        'bashls',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'html',
        'gopls',
        'gradle_ls',
        'groovyls',
        'lua_ls',
        'jdtls',
        'jsonls',
        'lemminx',
        'marksman',
        'pylsp',
        'quick_lint_js',
        'ts_ls',
        'vuels',
        'yamlls',
      },
      automatic_enable = {
        exclude = {
          -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
          'jdtls',
        }
      }
    })

    require('mason-tool-installer').setup({
      -- Install these linters, formatters, debuggers automatically
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
      },
    })

    -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
    vim.api.nvim_command('MasonToolsInstall')

    -- Lua LSP settings
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.stdpath "config" .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.config('html', {
        filetypes = { "html", "xhtml" }, -- Ensure 'xhtml' filetype is included
    })

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end

  end
}


-- require'lspconfig'.bashls.setup{}
-- require("lspconfig").ts_ls.setup({})
-- require("lspconfig").gopls.setup({})
-- require'lspconfig'.dockerls.setup{}
-- require'lspconfig'.docker_compose_language_service.setup{}
-- require'lspconfig'.jsonls.setup{}
-- require'lspconfig'.pylsp.setup{}
-- require'lspconfig'.vuels.setup{}

-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Enable completion triggered by <c-x><c-o>
--     vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wl', function()
--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, opts)
--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', '<space>f', function()
--       vim.lsp.buf.format { async = true }
--     end, opts)
--   end,
-- })
