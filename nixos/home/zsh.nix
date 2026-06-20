{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    history = {
      path = "$HOME/.histfile";
      size = 1000;
      save = 2000;
    };

    #---------------------------------------

    shellAliases = {
      # Tmux
      tt = "tmux";

      # Eza (ls with icons)
      ll = "eza --icons=always";
      lll = "eza --icons=always -l";

      # Quick exit
      xx = "exit";

      # Nix flake updates
      editNixFlake = "sudo nvim /etc/nixos/flake.nix";
      editNixConfig = "sudo nvim /etc/nixos/configuration.nix";
      nixRebuild = "sudo nixos-rebuild switch --flake .#SpiritBox";
      nixUpdate = "cd ~/Stuff/Private/Dots_GitHub/nixos && sudo nix flake update && nixRebuild && cd -";

      # Ports for localsend
      open-localsend = "sudo iptables -I nixos-fw 1 -p tcp --dport 53317 -j nixos-fw-accept && sudo iptables -I nixos-fw 1 -p udp --dport 53317 -j nixos-fw-accept";
      close-localsend = "sudo iptables -D nixos-fw -p tcp --dport 53317 -j nixos-fw-accept && sudo iptables -D nixos-fw -p udp --dport 53317 -j nixos-fw-accept";

      # Shell llm
      tgptd="tgpt --provider duckduckgo";

      # Swap size change
      swap_20g="~/Stuff/Github/SystemPrograms/swap_20g.sh";
      swap_8g="~/Stuff/Github/SystemPrograms/swap_8g.sh";

      # PC control/stats
      nvme_health="sudo nvme smart-log /dev/nvme1n1";
      cpu_temp="sensors | grep Tctl";
      bat_thresh_status="cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      bat_thresh_on="echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null && cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      bat_thresh_off="echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode >> /dev/null && cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      ryzen_boost_status="cat /sys/devices/system/cpu/cpufreq/boost";
      ryzen_boost_on="echo '1' | sudo tee /sys/devices/system/cpu/cpufreq/boost";
      ryzen_boost_off="echo '0' | sudo tee /sys/devices/system/cpu/cpufreq/boost";
      nvidia_status="cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status";

      # Keyboard backlight colors
      kbl_pink="kbl 401010 401010 401010 401010";
      kbl_orange="kbl 581f00 581f00 581f00 581f00";
      kbl_orange_intense="kbl 9b1f00 9b1f00 9b1f00 9b1f00";
      kbl_blue="kbl 3E6390 3E6390 3E6390 3E6390";
      kbl_cyberpink="kbl EE39C6 EE39C6 EE39C6 EE39C6";
      kbl_red_low="kbl 440000 440000 440000 440000";
      kbl_red_mid="kbl 990000 990000 990000 990000";
      kbl_red_high="kbl ff0000 ff0000 ff0000 ff0000";
      kbl_red_blue="kbl 880000 880000 000088 000088";
      kbl_cyber_red_blue="kbl 660511 660511 112266 112266";
      kbl_leaf_green="kbl 224400 224400 224400 224400 1";
      kbl_white="kbl 886688 886688 886688 886688 1";
      kbl_white_low="kbl 443344 443344 443344 443344 1";
      kbl_purple_splotch="kbl 110044 222244 222244 110044";

      # Reload zshrc (only for testing purposes, .zshrc over written by nix)
      reloadZshrc="source ~/.zshrc";

      # OCR workflow - KDE
      grab_text="flameshot gui --raw | \
        tesseract stdin stdout | \
        xclip -in -selection clipboard";

      # Youtube
      yt-dlp-def="yt-dlp --extract-audio --audio-format mp3 --audio-quality 0";
      yt-dlp-audio-solver="yt-dlp --remote-components ejs:github --extract-audio --audio-format mp3 --audio-quality 0";
      yt-dlp-video-solver="yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' --remote-components ejs:github";

      # Shortwave download folder
      shortwave_cache="cd ~/.var/app/de.haeckerfelix.Shortwave/cache/Shortwave/recording";

      # Go to dots
      go_to_dotfiles = "cd \${dot_file_loc}";

      # Get International Space Station coordinates
      trackISS="curl --silent http://api.open-notify.org/iss-now.json | jq";

      # https://www.gnu.org/software/wget/manual/wget.html
      weboffline="wget -E -H -k -K -p";
    };

    #---------------------------------------

    plugins = [
      {
        # Zsh auto-suggestions
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        # Zsh syntax highlightiin
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

    #---------------------------------------

    sessionVariables = {

      LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib:/run/opengl-driver/lib:\${LD_LIBRARY_PATH}";

      XLA_FLAGS = "--xla_gpu_cuda_data_dir=\${CONDA_PREFIX}";

      dot_file_loc = "~/Stuff/Private/Dots_GitHub";

      venvLoc = "PyVenv";

      GREEN   = "\\033[32;1m";
      RED     = "\\033[0;31m";
      WHITE   = "\\033[37;0;4m";
      WHITEBG = "\\033[37;100;1m";
      CYAN    = "\\033[96m";
      CYANB   = "\\033[96;1m";
      YELLOWB = "\\033[93;1m";
      RESET   = "\\033[0m";
      counter = "0";
    };

    #---------------------------------------

    initContent = ''
      # Disable dir highlight
      export LS_COLORS=$LS_COLORS:'ow=1;34:'

      # Disable terminal beep
      unsetopt beep

      # Ignore history
      setopt HIST_IGNORE_SPACE

      # Completion
      autoload -Uz compinit
      compinit
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' correct yes
      zstyle ':completion:*' max-errors 2
      zstyle ':completion:*' completer _expand _complete _correct _approximate
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Open new tab in cwd
      autoload -Uz add-zsh-hook
      function update_pwd() {
        printf '\e]7;file://%s%s\e\\' "$HOST" "$PWD"
      }
      add-zsh-hook chpwd update_pwd
      update_pwd

      # PATH additions
      export PATH=$PATH:~/.local/bin

      # Python virtual environments (venv)
      # Make python virtual environment in ~/PyVenv:
      function pyVenvMake () { python3 -m venv ~/$venvLoc/$1; }
      # Activate python virtual environment in ~/PyVenv:
      function pyVenvActivate () { source ~/$venvLoc/$1/bin/activate; }
      # List python virtual environments in ~/PyVenv:
      alias pyVenvList="ls ~/$venvLoc/"
      # Go directly to python project directory:
      function jump2PyProj () { cd ~/Stuff/PythonPrograms/; }

      # Set keyboard backlight
      function kbl() {
        pyVenvActivate l5p_kbl
        python3 ~/Stuff/Github/SystemPrograms/l5p-kbl/l5p_kbl.py static \
          ''${1:-603030} \
          ''${2:-603030} \
          ''${3:-603030} \
          ''${4:-603030} \
          --brightness ''${5:-1}
        deactivate
      }

      # Turn off keyboard backlight
      function kbl_off () {
        pyVenvActivate l5p_kbl
        python3 ~/Stuff/Github/SystemPrograms/l5p-kbl/l5p_kbl.py off
        deactivate
      }
    '';
  };

  #---------------------------------------

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Get nix to link starship config to the one in this dir
  xdg.configFile."starship.toml".source = ./starship.toml;
}
