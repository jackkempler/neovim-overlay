pkgs: with pkgs.vimPlugins; [
  lualine-nvim
  (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars))
  gruvbox-nvim
  neo-tree-nvim
  nui-nvim
  plenary-nvim
  nvim-web-devicons
  toggleterm-nvim
  tiny-inline-diagnostic-nvim
]
