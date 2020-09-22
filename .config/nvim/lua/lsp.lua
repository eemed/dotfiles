local nvim_lsp = require('nvim_lsp')

local function sort_by_key(fn)
    return function(a,b)
        local ka, kb = fn(a), fn(b)
        assert(#ka == #kb)
        for i = 1, #ka do
            if ka[i] ~= kb[i] then
                return ka[i] < kb[i]
            end
        end
        -- every value must have been equal here, which means it's not less than.
        return false
    end
end

local position_sort = sort_by_key(function(v)
    return {v.range.start.line, v.range.start.character}
end)

vim.lsp.util.buf_diagnostics_virtual_text = function() return end

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_command('setlocal signcolumn=yes')

    do
        local method = "textDocument/publishDiagnostics"
        local default_callback = vim.lsp.callbacks[method]
        vim.lsp.callbacks[method] = function(err, method, result, client_id)
            default_callback(err, method, result, client_id)
            if result and result.diagnostics then
                local result_bufnr = vim.uri_to_bufnr(result.uri)
                local bufnr = vim.api.nvim_win_get_buf(0)
                if result_bufnr == bufnr then
                    table.sort(result.diagnostics, position_sort)
                    for _, v in ipairs(result.diagnostics) do
                        v.bufnr = vim.uri_to_bufnr(result.uri)
                        v.lnum = v.range.start.line + 1
                        v.col = v.range.start.character + 1
                        v.text = v.message
                    end
                    vim.lsp.util.set_loclist(result.diagnostics)
                end
            end
        end
    end

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
