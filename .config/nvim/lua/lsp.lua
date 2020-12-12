----------------------
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

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end
----------------------
local M = {}

local lspconfig = require('lspconfig')

-- vim.lsp.util.buf_diagnostics_virtual_text = function() return end
M.default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

function M.publish_diagnostics(err, method, result, client_id, bufnr, config)
    if result and result.diagnostics then
        vim.lsp.diagnostic.buf_clear_diagnostics(bufnr)

        M.default_publish_diagnostics(err, method, result, client_id, bufnr, config)

        table.sort(result.diagnostics, position_sort)
        for _, v in ipairs(result.diagnostics) do
            v.bufnr = bufnr
            v.lnum = v.range.start.line + 1
            v.col = v.range.start.character + 1
            v.text = v.message
        end

        vim.lsp.diagnostic.save(bufnr, result.diagnostics)

        M.refresh_diagnostics()
    end
end

function M.refresh_diagnostics()
    local bufnr = vim.api.nvim_win_get_buf(0)
    local diagnostics = vim.lsp.util.diagnostics_by_buf[bufnr]
    if diagnostics == nil then
        return
    end
    vim.lsp.util.buf_diagnostics_signs(bufnr, diagnostics)
    vim.lsp.util.set_loclist(diagnostics)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    virtual_text = false,
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

function M.on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_command('setlocal signcolumn=yes')
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = M.publish_diagnostics

    -- vim.api.nvim_command [[augroup DiagnosticRefresh]]
    -- vim.api.nvim_command("autocmd! * <buffer>")
    -- vim.api.nvim_command [[autocmd BufEnter,BufWinEnter,TabEnter <buffer> lua require('lsp').refresh_diagnostics()]]
    -- vim.api.nvim_command [[augroup end]]

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
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>e' , '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>' , opts)
    vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>a' , '<cmd>lua vim.lsp.buf.code_action()<CR>' , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'         , opts)
    --
    -- hover on location list move
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[L', '<cmd>lfirst<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[l', '<cmd>lprev<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']l', '<cmd>lnext<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']L', '<cmd>llast<cr><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
end

local servers = {'bashls', 'tsserver', 'pyls', 'rust_analyzer'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = M.on_attach,
    }
end

return M
