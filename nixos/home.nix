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
  
  # Default fonts / icons
  dconf.enable = true;
  dconf.settings."org/gnome/desktop/interface" = {
    font-name = "IBM Plex Sans Medium 10";
    document-font-name = "IBM Plex Sans Text 10";
    monospace-font-name = "FiraCode Nerd Font 10";
    icon-theme = "Flat-Remix-Black-Dark";
  };

  gtk.enable = true;   # keep this if you want GTK theming managed by HM, just not the font

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "IBM Plex Sans" ];   # <-- tells apps to prefer it when asking generically
  };

  # Icon themes
  gtk.iconTheme = {
    name = "Flat-Remix-Black-Dark";
  };

  # Defafult apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # File manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # PDF / documents — GNOME Papers
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/postscript" = "org.gnome.Papers.desktop";
      "application/x-dvi" = "org.gnome.Papers.desktop";

      # Video — GNOME Videos (Showtime)
      "video/mp4" = "org.gnome.Showtime.desktop";
      "video/x-matroska" = "org.gnome.Showtime.desktop";
      "video/webm" = "org.gnome.Showtime.desktop";
      "video/x-msvideo" = "org.gnome.Showtime.desktop";

      # Music — GNOME Music
      "audio/mpeg" = "org.gnome.Decibels.desktop";
      "audio/flac" = "org.gnome.Decibels.desktop";
      "audio/x-wav" = "org.gnome.Decibels.desktop";
      "audio/ogg" = "org.gnome.Decibels.desktop";
      "audio/aac" = "org.gnome.Decibels.desktop";
      "audio/mp4" = "org.gnome.Decibels.desktop";
      "audio/x-m4a" = "org.gnome.Decibels.desktop";

      # Images — GNOME Loupe (Image Viewer)
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";


      # Text files — GNOME Text Editor
      "text/plain" = "org.gnome.TextEditor.desktop";

      # Archives — File Roller
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";

      # Fonts — GNOME Font Viewer
      "font/ttf" = "org.gnome.font-viewer.desktop";
      "font/otf" = "org.gnome.font-viewer.desktop";
      "application/x-font-ttf" = "org.gnome.font-viewer.desktop";

      # Web
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
