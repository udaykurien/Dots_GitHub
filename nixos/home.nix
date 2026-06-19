{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./home/neovim.nix
    ./home/zsh.nix
  ];

  home.username = "echoes";
  home.homeDirectory = "/home/echoes";
  home.stateVersion = "26.05"; # match your NixOS release

  # let Home Manager manage itself
  programs.home-manager.enable = true;
}
