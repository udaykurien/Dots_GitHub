{ config, pkgs, pkgs-unstable, system, caelestia-shell, ... }:

{
  imports = [
    ./home/neovim.nix
    ./home/zsh.nix
  ];

  home.username = "echoes";
  home.homeDirectory = "/home/echoes";
  home.stateVersion = "26.05"; # match your NixOS release
  
  home.packages = [
    caelestia-shell.packages.${system}.with-cli  # with-cli for full functionality
  ];

  # let Home Manager manage itself
  programs.home-manager.enable = true;
}
