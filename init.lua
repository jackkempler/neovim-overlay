-- ====================================================================
-- Leader Key & Vim Globals (Must be defined first!)
-- ====================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.clipboard = "unnamedplus"

-- ====================================================================
-- LSP Configuration (With automatic root directory detection)
-- ====================================================================
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
    local server_config = lsp_servers[args.match]
    if server_config then
      -- Detect project root using standard markers or fall back to active terminal directory
      local root_markers = { '.git', 'flake.nix', 'init.lua', 'Cargo.toml', 'package.json' }
      local root_dir = vim.fs.root(args.buf, root_markers) or vim.loop.cwd()

      vim.lsp.start({
        name = server_config.name,
        cmd = server_config.cmd,
        root_dir = root_dir,
      }, { bufnr = args.buf })
    end
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

vim.cmd([[colorscheme gruvbox]])

require('nvim-treesitter').setup({
  highlight = { enable = true },
  indent = { enable = true },
})

-- ====================================================================
-- Terminal (Toggleterm) Setup
-- ====================================================================
require("toggleterm").setup({
  size = 20,
  direction = 'horizontal',
})

local function smart_toggle_term()
  local term_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "toggleterm" then
      term_win = win
      break
    end
  end

  if not term_win then
    vim.cmd("ToggleTerm")
  elseif vim.api.nvim_get_current_win() == term_win then
    vim.cmd("wincmd p") -- Toggles focus back to last active buffer
  else
    vim.api.nvim_set_current_win(term_win)
    vim.cmd("startinsert")
  end
end

-- Keybind: Space + t (leader t) in Normal Mode to focus/toggle terminal
vim.keymap.set('n', '<leader>t', smart_toggle_term, { silent = true, desc = "Focus/Open Terminal" })

-- Easily toggle back to the main buffer from inside terminal window using Space + t
vim.keymap.set('t', '<leader>t', '<C-\\><C-n><C-w>p', { silent = true, desc = "Escape Terminal Focus" })

-- ====================================================================
-- File Tree (Neo-Tree) Setup
-- ====================================================================
require("neo-tree").setup({
  close_if_last_window = true,
  event_handlers = {
    -- Automatically close Neo-tree sidebar as soon as a file is successfully opened
    {
      event = "file_opened",
      handler = function(file_path)
        require("neo-tree.sources.manager").close("filesystem")
      end
    },
  },
  window = {
    width = 30,
    mappings = {
      ["<space>"] = "none", -- Disable default space bar actions
    }
  }
})

local function smart_toggle_neotree()
  local neotree_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" then
      neotree_win = win
      break
    end
  end

  if not neotree_win then
    vim.cmd("Neotree focus") -- Spawns filetree and puts focus directly on it
  elseif vim.api.nvim_get_current_win() == neotree_win then
    vim.cmd("wincmd p")
  else
    vim.api.nvim_set_current_win(neotree_win)
  end
end

-- Chained Keybind: Space + f + e (leader f e) to open/focus the file tree
vim.keymap.set('n', '<leader>fe', smart_toggle_neotree, { silent = true, desc = "Focus/Open File Tree" })

-- ====================================================================
-- Diagnostics Configuration (Tiny-Inline-Diagnostic)
-- ====================================================================
require("tiny-inline-diagnostic").setup({
  preset = "nonerdfont",
})

-- Default diagnostic rendering setup
vim.diagnostic.config({
  virtual_text = false, -- Prevent standard virtual text from colliding
  signs = {
    severity = { min = vim.diagnostic.severity.WARN } -- Show warnings & errors in sign column by default
  }
})

-- Keybind: Space + Shift + D (leader D) in Normal Mode to toggle diagnostics on/off
vim.keymap.set('n', '<leader>uD', function()
  require("tiny-inline-diagnostic").toggle()
end, { silent = true, desc = "Toggle Inline Diagnostics" })

-- Keybind: Space + d (leader d) in Normal Mode to toggle Error-Only vs Error+Warn
local error_only_mode = false

vim.keymap.set('n', '<leader>ud', function()
  error_only_mode = not error_only_mode

  if error_only_mode then
    -- Show ONLY Errors (hides Warnings "W" in the gutter)
    vim.diagnostic.config({
      signs = {
        severity = { min = vim.diagnostic.severity.ERROR }
      }
    })
    require("tiny-inline-diagnostic").change_severities({
      vim.diagnostic.severity.ERROR
    })
    print("Diagnostics: Errors Only")
  else
    -- Restore Errors & Warnings (displays warnings in the gutter)
    vim.diagnostic.config({
      signs = {
        severity = { min = vim.diagnostic.severity.WARN }
      }
    })
    require("tiny-inline-diagnostic").change_severities({
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN
    })
    print("Diagnostics: Errors & Warnings")
  end
end, { silent = true, desc = "Toggle Diagnostic Severity Level" })

-- ====================================================================
-- Lualine with Clipboard Helper Component
-- ====================================================================
local function clipboard_preview()
  local clipboard = vim.fn.getreg("+")
  if not clipboard or clipboard == "" then
    return ""
  end

  local clean = clipboard:gsub("^%s*(.-)%s*$", "%1"):gsub("\n", " ")

  if #clean > 20 then
    clean = string.sub(clean, 1, 17) .. "..."
  end

  return "📋 " .. clean
end

require("lualine").setup({
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = '',
    icons_enabled = false
  },
  sections = {
    lualine_y = { clipboard_preview },
  }
})

-- Terminal Buffer copy automation: Ctrl + Shift + Y to yank terminal scrollback
vim.keymap.set('t', '<C-S-y>', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")
  vim.fn.setreg('+', text)
  print("Terminal history copied to clipboard!")
end, { silent = true, desc = "Yank entire terminal history" })
