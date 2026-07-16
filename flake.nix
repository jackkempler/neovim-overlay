{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {self, nixpkgs}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    neovim = p: p.wrapNeovimUnstable p.neovim-unwrapped { 
      wrapperArgs = ["--prefix" "PATH" ":" (p.lib.makeBinPath (import ./runtime.nix p))];
      plugins = import ./plugins.nix p;
      luaRcContent = builtins.readFile ./init.lua;
    };
  in {
    packages.${system}.default = neovim pkgs;
    overlays.default = final: prev: {neovim = neovim final;};
  };
}
