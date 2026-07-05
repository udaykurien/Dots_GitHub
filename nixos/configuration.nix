# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, lib,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot settings.
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    initrd.kernelModules = [ "amdgpu" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [ "acpi_backlight=native" "quiet" "splash" "udev.log_priority=3" "rd.systemd.show_status=false" "nvidia-drm.modeset=1" "amd_pstate=active" ];
    # kernel.sysfs.devices.system.cpu.cpufreq.boost = "0"; # Disable Ryzen 7 5800H boost - but also locks power management from within linux
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 3;
    loader.efi.canTouchEfiVariables = true;
    plymouth = {
      enable = true;
      theme = "connect";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "connect" ];
        })
      ];
    };
  };

  # Run garbage collector on schedule.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };


  # Nvidia driver.
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking.hostName = "SpiritBox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "127.0.0.1" ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        local-zone = ''"use-application-dns.net." static'';
      };
      forward-zone = [{
        name = ".";
        forward-tls-upstream = true;
        forward-addr = [
          "9.9.9.9@853#dns.quad9.net"
          "149.112.112.112@853#dns.quad9.net"
          "2620:fe::fe@853#dns.quad9.net"
          "2620:fe::9@853#dns.quad9.net"
        ];
      }];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

#  # Enable the KDE Plasma Desktop Environment.
#  services.displayManager.sddm.enable = true;
#  services.desktopManager.plasma6.enable = true;

  # Enable GNOME Desktop Environment:
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # Enable virtualization.
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable niri
  programs.niri.enable = true;

  # Enable mango
  programs.mangowc.enable = true;
  
  # Enable hyprland
  programs.hyprland.enable = true;
  
  # Enable DMS
  programs.dms-shell.enable = true;
  programs.dsearch = {
    enable = true;
    systemd.enable = true;
  };

  systemd.user.services.dms = {
    wantedBy = lib.mkForce [ ];
  };

#  # Enable fractional scaling (Gnome < 50).
#  services.desktopManager.gnome.extraGSettingsOverrides = ''
#    [org.gnome.mutter]
#    experimental-features=['scale-monitor-framebuffer']
#  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set up mpd for mpc music player
  services.mpd = {
    enable = true;
    settings = {
      music_directory = "/home/echoes/Music/";
      audio_output = [
        {
          type = "pipewire";
          name = "My PipeWire Output";
#          type = "pulse";
#          name = "Pulseaudio";
#          server = "127.0.0.1";
        }
      ];
    };
    # Optional:
    startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };

  # Fix mpd - pipwire interaction bug as per NixOS wiki (https://wiki.nixos.org/wiki/MPD)
  services.mpd.user = "echoes";
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.echoes.uid}";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.echoes = {
    isNormalUser = true;
    description = "echoes";
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "input" ]; # input - for evdev in autokbl
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  kdePackages.kate
    #  thunderbird
    ];
  };

  # Nix settings.
  nix.settings = {
    max-jobs = 3;
    cores = 4;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
    download-buffer-size = 524288000;
  };

  # Set up flatpaks
  services.flatpak.enable = true;
  services.flatpak.update.onActivation = true;
  
  # Niri module already adss these xdg's, so no need to include them here
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

  # Give flatpak apps access to gtk theme directories
  services.flatpak.overrides.settings = {
    global.Context.filesystems = [
      "xdg-config/gtk-3.0:ro"
      "xdg-config/gtk-4.0:ro"
    ];
  };

  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];

  # Session variables are set on first log in
  environment.sessionVariables = {
    XDG_DATA_DIRS = [ "/var/lib/flatpak/exports/share" "$HOME/.local/share/flatpak/exports/share" ]; # Flatpaks
    AI_PROVIDER = "sky"; # Tgpt, update it when there is a better provider
    CUDA_PATH = "${pkgs.cudaPackages.cuda_cudart}";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    WLR_DRM_DEVICES = "/dev/dri/card1"; # Offload niri to integrated graphics instead of nvidia
    LIBVA_DRIVER_NAME = "radeonsi"; # stop youtube from defaulting to 360p
    MOZ_ENABLE_WAYLAND = "1";
  };

  # udev rules.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c965", MODE="0666"
    # Power off NVIDIA GPU when not in use
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{power/control}="auto"
'';

  # Systemd service for auto kbl
systemd.services.l5p-autobl = {
  description = "L5P Keyboard Backlight Auto Controller";
  wantedBy = [ "multi-user.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    ExecStart = "/run/current-system/sw/bin/python3 /home/echoes/Stuff/Github/SystemPrograms/l5p-kbl-autorun/NixOS/l5p_kbl_auto_on_off.py";
    Restart = "on-failure";
    User = "echoes";
    Environment = "LD_LIBRARY_PATH=/run/current-system/sw/share/nix-ld/lib";
  };
};

  # Install firefox.
  programs.firefox = {
  enable = true;
  policies = {
    DNSOverHTTPS = {
      Enabled = false;
      Locked = true;
    };
  };
};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Install steam
  programs.steam.enable = true;

  # To fix numpy and dll errors.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib   # provides libstdc++.so.6
      zlib
      libusb1
      cudaPackages.cuda_cudart
      cudaPackages.cudnn
      cudaPackages.libcublas
      cudaPackages.libcurand
      cudaPackages.libcufft
      cudaPackages.libcusolver
      cudaPackages.libcusparse
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [ evdev pyusb ]))
    adw-gtk3
    adwaita-icon-theme
    binutils
    blanket
    brightnessctl
    btop
    cmatrix
    cmus
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    cudaPackages.cudnn
    cudaPackages.libcublas
    cudaPackages.libcurand
    cudaPackages.libcufft
    cudaPackages.libcusolver
    cudaPackages.libcusparse
    curl
    deja-dup
#    discord
    ## DOOM EMACS dependencies ##
    emacs
    ripgrep
    fd
    gnutls
    (aspellWithDicts (dicts: with dicts; [ en ]))
    #############################
    eloquent
    exfatprogs
    exiftool
    eza
    fastfetch
    file
    foliate
#    gamescope 
    gcc
    ghostty
    gnumake
    gimp-with-plugins
    git
    gnome-boxes
    gnome-disk-utility
    gnomeExtensions.appindicator
    gnome-extension-manager
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-history
    gnomeExtensions.color-picker
    gnomeExtensions.gtile
    gnomeExtensions.just-perfection
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
    gnome-tweaks
    gnome-text-editor
    gnumake
    gparted
    # grim
    # grimblast
    hicolor-icon-theme
    htop
    id3v2
    jdk21
    # kooha
    libreoffice
    librewolf
    localsend
    lynis
    macchanger
    mpc
    ncmpcpp
    lshw
    nasm
    nautilus
    ncdu
    neovim
    noctalia-shell
    nodejs
    nvme-cli
    obs-studio
    pciutils
    pdfarranger
    planify
    psmisc
    pyradio
    python3
    python313Packages.yt-dlp-ejs
    pywalfox-native
    ranger
    resources
    rubberband
#   signal-desktop-bin
#   slurp
    starship
    tcpdump
    tgpt
    tmux
    tree
    tree-sitter
    tuxguitar
    unzip
    usbutils
    vimPlugins.vim-plug
    vlc
    wgnord # Follow instructions from here: https://github.com/phirecc/wgnord
    wget
    wl-clipboard
    xwayland-satellite
    yaru-theme
    yt-dlp
#    pkgs-unstable.zed-editor
    zed-editor
    zsh
  ];

  # Fonts.
  fonts.packages = with pkgs; [
    ibm-plex
    fira-code
    nerd-fonts.fira-code
  ];

  # Flatpak apps.
  services.flatpak.packages = [
    { appId = "de.haeckerfelix.Shortwave"; origin = "flathub"; }
    { appId = "com.stremio.Stremio"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "org.musicbrainz.Picard"; origin = "flathub"; }
    { appId = "io.github.revisto.drum-machine"; origin = "flathub"; }
#   { appId = "com.valvesoftware.Steam"; origin = "flathub"; }
    { appId = "io.github.shonebinu.Defuse"; origin = "flathub"; }
    { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
#    { appId = "com.vscodium.codium"; origin = "flathub"; }
    { appId = "org.signal.Signal"; origin = "flathub"; }
    { appId = "com.brave.Browser"; origin = "flathub"; }
#   { appId = "io.gitlab.librewolf-community"; origin = "flathub"; } 
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
