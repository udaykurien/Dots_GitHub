{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    #    ./home/neovim.nix
    ./home/zsh.nix
  ];
  
  # qt = {
  #   enable = true;
  #   platformTheme.name = "qt6ct";
  #   style.name = "breeze";
  # };

  home.username = "echoes";
  home.homeDirectory = "/home/echoes";
  home.stateVersion = "26.05"; # match your NixOS release
  
  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];

 # let Home Manager manage itself
  programs.home-manager.enable = true;
}
