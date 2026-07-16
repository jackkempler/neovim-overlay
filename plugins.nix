pkgs: with pkgs.vimPlugins; [
  lualine-nvim
  (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars))
]
