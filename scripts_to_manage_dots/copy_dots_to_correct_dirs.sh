#!/bin/bash

# niri
mkdir -p /home/echoes/.config/niri
ln -s ~/Stuff/Private/Dots_GitHub/niri/config.kdl /home/echoes/.config/niri/

# hyprland
mkdir -p /home/echoes/.config/hypr
ln -s ln -s ~/Stuff/Private/Dots_GitHub/hyprland/hyprland.conf /home/echoes/.config/hypr/
ln -s ln -s ~/Stuff/Private/Dots_GitHub/hyprland/hyprpaper.conf /home/echoes/.config/hypr/

# zshrc
ln -s ~/Stuff/Private/Dots_GitHub/zsh/zshrc_main ~/.zshrc

# nvmim
mkdir -p ~/.config/nvim/
ln -s ~/Stuff/Private/Dots_GitHub/nvim/init.vim ~/.config/nvim/


