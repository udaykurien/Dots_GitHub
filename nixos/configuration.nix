# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nvidia driver
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
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
  
  # Boot params
  boot.kernelParams = [ "acpi_backlight=native" ]; # Get backlight control to work
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  boot.initrd.luks.devices."luks-1783d8d4-c954-45a9-9496-d27748ef5ef8".device = "/dev/disk/by-uuid/1783d8d4-c954-45a9-9496-d27748ef5ef8";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
   services.xserver.desktopManager.gnome.enable = true;
   services.xserver.displayManager.gdm.enable = true;
   services.xserver.displayManager.gdm.wayland = true;
 
   # Enable fractional scaling (Gnome < 50).
   services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
     [org.gnome.mutter]
     experimental-features=['scale-monitor-framebuffer']
  '';

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.echoes = {
    isNormalUser = true;
    description = "echoes";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  kdePackages.kate
    #  thunderbird
    ptyxis
    ];
  };
  
  # Enable flakes and experimental commands.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # For pre-built cuda binary caches
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Set up flatpaks
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

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
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # To fix numpy and dll errors.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib   # provides libstdc++.so.6
      zlib
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
  	#vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	adwaita-icon-theme
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
	eza
	fastfetch
	git
    gnome-extension-manager
	gnome-tweaks
	hicolor-icon-theme
	htop
	libreoffice
	librewolf
	ncdu
	neovim
	nodejs
	pdfarranger
	python3
	resources
	starship
	tgpt
	wget
	wl-clipboard
	yaru-theme
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
