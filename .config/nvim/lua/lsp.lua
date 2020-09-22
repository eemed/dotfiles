local nvim_lsp = require('nvim_lsp')

local on_attach = function(client, bufnr)
    require'diagnostic'.on_attach(client)

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
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>a' , '<cmd>lua vim.lsp.buf.code_action()<CR>' , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'         , opts)
end

local servers = {'bashls', 'tsserver', 'pyls', 'rust_analyzer'}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end
