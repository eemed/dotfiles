require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "bash", "lua", "vim", "help", "javascript", "typescript", "java" },
  sync_install = true,
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "`",
    },
  },
}
