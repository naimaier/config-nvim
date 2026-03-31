-- Icons to use in the completion menu.
-- These are the ones that VSCode uses.
local cmp_kinds = {
    Text = '  ',
    Method = '  ',
    Function = '  ',
    Constructor = '  ',
    Field = '  ',
    Variable = '  ',
    Class = '  ',
    Interface = '  ',
    Module = '  ',
    Property = '  ',
    Unit = '  ',
    Value = '  ',
    Enum = '  ',
    Keyword = '  ',
    Snippet = '  ',
    Color = '  ',
    File = '  ',
    Reference = '  ',
    Folder = '  ',
    EnumMember = '  ',
    Constant = '  ',
    Struct = '  ',
    Event = '  ',
    Operator = '  ',
    TypeParameter = '  ',
    Copilot = '  ',
}

-- Auto-completion / Snippets
return {
    -- https://github.com/hrsh7th/nvim-cmp
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- https://github.com/saadparwaiz1/cmp_luasnip
        'saadparwaiz1/cmp_luasnip',

        -- LSP completion capabilitie
        -- https://github.com/hrsh7th/cmp-nvim-lsp
        'hrsh7th/cmp-nvim-lsp',

        -- Additional user-friendly snippets
        -- https://github.com/rafamadriz/friendly-snippets
        'rafamadriz/friendly-snippets',
        -- https://github.com/hrsh7th/cmp-buffer
        'hrsh7th/cmp-buffer',
        -- https://github.com/hrsh7th/cmp-path
        'hrsh7th/cmp-path',
        -- https://github.com/hrsh7th/cmp-cmdline
        'hrsh7th/cmp-cmdline',
        {
            -- Snippet engine & associated nvim-cmp source
            -- https://github.com/L3MON4D3/LuaSnip
            'L3MON4D3/LuaSnip',
            config = function()
                local types = require 'luasnip.util.types'
                local luasnip = require('luasnip')

                require('luasnip.loaders.from_vscode').lazy_load()
                luasnip.filetype_extend("xhtml", {"html", "xml"}) -- treat xhtml as html
                --luasnip.config.setup({})

                luasnip.setup {
                    history = true,
                    delete_check_events = 'TextChanged',
                    -- Display a cursor-like placeholder in unvisited nodes
                    -- of the snippet.
                    ext_opts = {
                        [types.insertNode] = {
                            unvisited = {
                                virt_text = { { '|', 'Conceal' } },
                                virt_text_pos = 'inline',
                            },
                        },
                    },
                }
            end,
        }
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- Inside a snippet, use backspace to remove the placeholder.
        vim.keymap.set('s', '<BS>', '<C-O>s', { silent = true })

        cmp.setup({
            -- Add icons to the completion menu.
            formatting = {
                format = function(_, vim_item)
                    vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
                    return vim_item
                end,
                expandable_indicator = true,
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
                ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
                ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll backward
                ['<C-f>'] = cmp.mapping.scroll_docs(4), -- scroll forward
                ['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                -- Tab through suggestions or when a snippet is active, tab to the next argument
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                -- Tab backwards through suggestions or when a snippet is active, tab to the next argument
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- lsp 
                { name = "luasnip" }, -- snippets
                { name = "buffer" }, -- text within current buffer
                { name = "path" }, -- file system paths
            }),
            window = {
                -- Add borders to completions popups
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
                -- Disable the documentation popup. It gets too cluttered.
                --documentation = cmp.config.disable,
            },
        })
    end,
}
