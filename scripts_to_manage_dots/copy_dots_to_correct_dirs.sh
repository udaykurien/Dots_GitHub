# nix
sudo ln -s /home/echoes/Stuff/Private/Dots_GitHub/nixos /etc/nixos

# niri
mkdir -p /home/echoes/.config/niri
ln -s ~/Stuff/Private/Dots_GitHub/niri/config.kdl /home/echoes/.config/niri/

# hyprland
mkdir -p /home/echoes/.config/hypr
ln -s ~/Stuff/Private/Dots_GitHub/hyprland/hyprland.conf /home/echoes/.config/hypr/
ln -s ~/Stuff/Private/Dots_GitHub/hyprland/hyprpaper.conf /home/echoes/.config/hypr/

# zshrc
ln -s ~/Stuff/Private/Dots_GitHub/zsh/zshrc_main ~/.zshrc

# nvim
mkdir -p ~/.config/nvim/
ln -s ~/Stuff/Private/Dots_GitHub/nvim/init.vim ~/.config/nvim/

# kitty
ln -s ~/Stuff/Private/Dots_GitHub/kitty ~/.config/kitty

# ghostty
ln -s ~/Stuff/Private/Dots_GitHub/ghostty ~/.config/ghostty

# starship
ln -s ~/Stuff/Private/Dots_GitHub/starship/starship.toml ~/.config/starship.toml

# tmux
ln -s ~/Stuff/Private/Dots_GitHub/tmux/tmux.conf ~/.tmux.conf
