local nvim_lsp = require('nvim_lsp')

vim.lsp.util.buf_diagnostics_virtual_text = function() return end

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_command('setlocal signcolumn=yes')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gD'        , '<cmd>lua vim.lsp.buf.declaration()<CR>'            , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gd'        , '<cmd>lua vim.lsp.buf.definition()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'K'         , '<cmd>lua vim.lsp.buf.hover()<CR>'                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gi'        , '<cmd>lua vim.lsp.buf.implementation()<CR>'         , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gy'        , '<cmd>lua vim.lsp.buf.type_definition()<CR>'        , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gR'        , '<cmd>lua vim.lsp.buf.rename()<CR>'                 , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gr'        , '<cmd>lua vim.lsp.buf.references()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>f' , '<cmd>lua vim.lsp.buf.formatting()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>e' , '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>' , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'         , opts)
end

local servers = {'bashls', 'tsserver', 'pyls', 'rls'}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end

do
    local method = "textDocument/publishDiagnostics"
    local default_callback = vim.lsp.callbacks[method]
    vim.lsp.callbacks[method] = function(err, method, result, client_id)
        default_callback(err, method, result, client_id)
        if result and result.diagnostics then
            for _, v in ipairs(result.diagnostics) do
                v.bufnr = client_id
                v.lnum = v.range.start.line + 1
                v.col = v.range.start.character + 1
                v.text = v.message
            end
        end
        vim.lsp.util.set_loclist(result.diagnostics)
    end
end
