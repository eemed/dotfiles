local lspconfig = require('lspconfig')

local on_publish_diags = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(a, b, params, client_id, c, config)
    on_publish_diags(a, b, params, client_id, c, config)
    -- Add diagnostics to locationlist
    -- Doesnt work at the moment, index out of bounds
    -- vim.lsp.diagnostic.set_loclist({ open_loclist = false })
end


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)

    vim.api.nvim_command('setlocal signcolumn=yes')
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', '<leader>w', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[l', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']l', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    vim.keymap.set('n', '<leader>gD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local servers = {'bashls', 'tsserver', 'rust_analyzer', 'lua_ls'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup { }
end
