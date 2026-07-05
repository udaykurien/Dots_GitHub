{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    #    ./home/neovim.nix
    ./home/zsh.nix
  ];

  home.username = "echoes";
  home.homeDirectory = "/home/echoes";
  home.stateVersion = "26.05"; # match your NixOS release
  
  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];

  xdg.configFile."fastfetch/config.jsonc".source = ./home/fastfetch_config.jsonc;
 
 # let Home Manager manage itself
  programs.home-manager.enable = true;
}
