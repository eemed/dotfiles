local lspconfig = require('lspconfig')

local on_publish_diags = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(a, b, params, client_id, c, config)
    on_publish_diags(a, b, params, client_id, c, config)
    -- Add diagnostics to locationlist
    vim.lsp.diagnostic.set_loclist({ open_loclist = false })
end

function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_command('setlocal signcolumn=yes')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gD'        , '<cmd>lua vim.lsp.buf.declaration()<CR>'                                 , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gd'        , '<cmd>lua vim.lsp.buf.definition()<CR>'                                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'K'         , '<cmd>lua vim.lsp.buf.hover()<CR>'                                       , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gi'        , '<cmd>lua vim.lsp.buf.implementation()<CR>'                              , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gy'        , '<cmd>lua vim.lsp.buf.type_definition()<CR>'                             , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gR'        , '<cmd>lua vim.lsp.buf.rename()<CR>'                                      , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gr'        , '<cmd>lua vim.lsp.buf.references()<CR>'                                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>f' , '<cmd>call LspFormat()<CR>'                                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>e' , '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'                , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>a' , '<cmd>lua vim.lsp.buf.code_action()<CR>'                                 , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'                              , opts)

    -- hover on location list move
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '[L'        , '<cmd>lfirst<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>' , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '[l'        , '<cmd>lprev<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>'  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , ']l'        , '<cmd>lnext<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>'  , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , ']L'        , '<cmd>llast<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>'  , opts)
end

local servers = {'bashls', 'tsserver', 'pyls', 'rust_analyzer', 'sumneko_lua'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
end
