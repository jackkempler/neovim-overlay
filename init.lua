vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

local lsp_servers = {
  nix = { name = 'nil', cmd = { 'nil' } },
  lua = { name = 'lua-language-server', cmd = { 'lua-language-server' } },
  rust = { name = 'rust-analyzer', cmd = { 'rust-analyzer' } },
  go = { name = 'gopls', cmd = { 'gopls' } },
  python = { name = 'pyright', cmd = { 'pyright-langserver', '--stdio' } },
  c = { name = 'clangd', cmd = { 'clangd' } },
  cpp = { name = 'clangd', cmd = { 'clangd' } },
  typescript = { name = 'typescript-language-server', cmd = { 'typescript-language-server', '--stdio' } },
  javascript = { name = 'typescript-language-server', cmd = { 'typescript-language-server', '--stdio' } },
  typescriptreact = { name = 'typescript-language-server', cmd = { 'typescript-language-server', '--stdio' } },
  javascriptreact = { name = 'typescript-language-server', cmd = { 'typescript-language-server', '--stdio' } },
  html = { name = 'vscode-html-language-server', cmd = { 'vscode-html-language-server', '--stdio' } },
  css = { name = 'vscode-css-language-server', cmd = { 'vscode-css-language-server', '--stdio' } },
  scss = { name = 'vscode-css-language-server', cmd = { 'vscode-css-language-server', '--stdio' } },
  less = { name = 'vscode-css-language-server', cmd = { 'vscode-css-language-server', '--stdio' } },
  json = { name = 'vscode-json-language-server', cmd = { 'vscode-json-language-server', '--stdio' } },
  yaml = { name = 'yaml-language-server', cmd = { 'yaml-language-server', '--stdio' } },
  markdown = { name = 'marksman', cmd = { 'marksman' } },
  toml = { name = 'taplo', cmd = { 'taplo', 'lsp', 'stdio' } },
  sh = { name = 'bash-language-server', cmd = { 'bash-language-server', 'start' } },
  bash = { name = 'bash-language-server', cmd = { 'bash-language-server', 'start' } },
  dockerfile = { name = 'docker-langserver', cmd = { 'docker-langserver', '--stdio' } },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(lsp_servers),
  callback = function(args)
    vim.lsp.start(lsp_servers[args.match], { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'K',  vim.lsp.buf.hover, 'Hover documentation')
    map('n', 'gr', vim.lsp.buf.references, 'Find references')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
  end,
})

require('nvim-treesitter').setup({
  highlight = { enable = true },
  indent = { enable = true },
})

require("lualine").setup({
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = '',
    icons_enabled = false
  }
})
