-- Always show sign column.
-- The sign column is used by the LSP support to show diagnostics
-- (the E, W, etc. characters on the side)
-- as well as by the Lean plugin to show the orange bars.
-- By default the sign column is only shown if there are signs to show,
-- which means the buffer will constantly jump right and left.
vim.opt.signcolumn = "yes:1"

-- Enable nvim-cmp, with 3 completion sources, including LSP
local luasnip = require("luasnip")
local cmp = require 'cmp'
cmp.setup {
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'})
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'path'}, {name = 'buffer'}
    })
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

cmp.setup.filetype('iml', {
    sources = cmp.config.sources({
        {
            name = 'omni',
            trigger_characters = {'.'},
            option = {disable_omnifuncs = {'v:lua.vim.lsp.omnifunc'}},
            completion = {
                autocomplete = {
                    require('cmp.types').cmp.TriggerEvent.TextChanged
                },
                keyword_length = 4
            }
        }
        -- {name = 'buffer'}
    })
})

-- Trigger on empty, too janky
-- https://github.com/hrsh7th/nvim-cmp/issues/519#issuecomment-1091109258
-- vim.api.nvim_create_autocmd(
--   {"TextChangedI", "TextChangedP"},
--   {
--     callback = function()
--       local line = vim.api.nvim_get_current_line()
--       local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--       local current = string.sub(line, cursor, cursor + 1)
--       if current == "." or current == "," or current == " " then
--         require('cmp').close()
--       end
--
--       local before_line = string.sub(line, 1, cursor + 1)
--       local after_line = string.sub(line, cursor + 1, -1)
--       if not string.match(before_line, '^%s+$') then
--         if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--           require('cmp').complete()
--         end
--       end
--   end,
--   pattern = "*"
-- })

local function fzf_table(sources)
    table.foreach(sources, function(k, v) sources[k] = vim.fn.shellescape(v) end)
    local query = table.concat(sources, ' ')
    vim.fn['fzf#vim#grep'](
        "rg --column --line-number --no-heading --color=always --smart-case -g '*.lean' -- '' " ..
            query, 1, vim.fn['fzf#vim#with_preview'](), 0)
end

-- You may want to reference the nvim-cmp documentation for further
-- configuration of completion: https://github.com/hrsh7th/nvim-cmp#recommended-configuration

-- Configure the language server:

-- You may want to reference the nvim-lspconfig documentation, found at:
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
-- The below is just a simple initial set of mappings which will be bound
-- within Lean files.
local function on_attach(_, bufnr)
    local function cmd(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, {noremap = true, buffer = true})
    end

    -- Autocomplete using the Lean language server
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- gd in normal mode will jump to definition
    cmd('n', 'gd', vim.lsp.buf.definition)
    -- K in normal mode will show the definition of what's under the cursor
    cmd('n', 'K', vim.lsp.buf.hover)

    cmd('n', '<space>e', vim.diagnostic.open_float)
    cmd('n', '[d', vim.diagnostic.goto_prev)
    cmd('n', ']d', vim.diagnostic.goto_next)

    -- <space>q will load all errors in the current lean file into the location list
    -- (and then will open the location list)
    cmd('n', '<space>q', vim.diagnostic.setloclist)

    -- <leader>K will show all diagnostics for the current line in a popup window
    cmd('n', '<leader>K', function()
        vim.lsp.diagnostic.show_line_diagnostics {show_header = false}
    end)

    cmd('n', '<space>g',
        function() fzf_table(require'lean'.current_search_paths()) end)
end

-- Enable lean.nvim, and enable abbreviations and mappings
require('lean').setup {
    abbreviations = {builtin = true},
    lsp = {on_attach = on_attach},
    lsp3 = {on_attach = on_attach},
    mappings = true
}

-- Update error messages even while you're typing in insert mode
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {spacing = 4},
        update_in_insert = true
    })

-- See https://github.com/theHamsta/nvim-semantic-tokens/blob/master/doc/nvim-semantic-tokens.txt
local mappings = {
    LspKeyword = "@keyword",
    LspVariable = "@variable",
    LspNamespace = "@namespace",
    LspType = "@type",
    LspClass = "@type.builtin",
    LspEnum = "@constant",
    LspInterface = "@type.definition",
    LspStruct = "@structure",
    LspTypeParameter = "@type.definition",
    LspParameter = "@parameter",
    LspProperty = "@property",
    LspEnumMember = "@field",
    LspEvent = "@variable",
    LspFunction = "@function",
    LspMethod = "@method",
    LspMacro = "@macro",
    LspModifier = "@keyword.function",
    LspComment = "@comment",
    LspString = "@string",
    LspNumber = "@number",
    LspRegexp = "@string.special",
    LspOperator = "@operator"
}

for from, to in pairs(mappings) do
    vim.cmd.highlight('link ' .. from .. ' ' .. to)
end
