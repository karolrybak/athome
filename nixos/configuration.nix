# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
    <home-manager/nixos>
    ./home-manager/3khome.nix
  ];

  nix = {
    settings.substituters = [ "https://nix-community.cachix.org" ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extraOptions = ''
      trusted-users = root kr
    '';
  };

  boot.loader = {
    timeout = 1;

    efi = { efiSysMountPoint = "/boot"; };

    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable =
        true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
      devices = [ "nodev" ];
      splashImage = "/etc/nixos/splash.png";
    };
  };
  networking = {
    hostName = "pc-kr"; # Define your hostname.
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
  boot.initrd.verbose = false;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;

    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.bluetooth.enable = true;

  # programs.hyprland = {
  #   # Install the packages from nixpkgs
  #   enable = true;
  #   # Whether to enable XWayland
  #   xwayland.enable = true;
  # };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     initial_session = {
  #       command = "${session}";
  #       user = "${username}";
  #     };
  #     default_session = {
  #       command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
  #       user = "greeter";
  #     };
  #   };
  # };

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    theme = "catpuccin-sddm";
    settings.AutoLogin = {
      enable = true;
      user = "kr";
    };
  };

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  programs.zsh = { enable = true; };
  users.defaultUserShell = pkgs.zsh;

  users.users.kr = {
    isNormalUser = true;
    description = "Karol";
    extraGroups = [
      "networkmanager"
      "dialout"
      "wheel"
      "docker"
      "podman"
      "adbusers"
      "tty"
      "disk"
      "video"
    ];
    shell = pkgs.zsh;
  };

  # users.users.dkr = {
  #   isNormalUser = true;
  #   description = "docker user";
  #   extraGroups = [ "networkmanager" "dialout" "wheel" "docker" "podman" ];
  #   shell = pkgs.zsh;
  # };

  # SYNCTHING

  services = {
    syncthing = {
      enable = true;
      user = "kr";
      dataDir = "/home/kr/Sync"; # Default folder for new synced folders
      configDir =
        "/home/kr/Sync/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };

  # THUNAR
  # programs.thunar.enable = true;
  # programs.thunar.plugins = with pkgs.xfce; [
  #  thunar-archive-plugin
  #  thunar-volman
  # ];

  # programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # cli tools
    bat
    ccze
    curl
    ffmpeg
    file
    fzf
    gh
    git
    glow
    htop
    inotify-tools
    jq
    just
    lsd
    micro
    ncdu
    ripgrep
    rsync
    tldr
    tmux
    tree
    wget
    wl-clipboard
    yazi
    zoxide
    xdg-utils
    sqlite
    zip
    unzip

    # Terminals
    alacritty
    cool-retro-term
    kitty
    terminator

    # Browsers
    google-chrome
    microsoft-edge
    qutebrowser
    librewolf-unwrapped
    floorp-unwrapped
    tor-browser    
    ungoogled-chromium

    # Containers
    nvidia-container-toolkit
    distrobox
    rootlesskit
    podman-compose
    podman-tui

    # Android
    android-tools
    scrcpy

    # 3KHome
    esphome
    ollama
    libtensorflow
    # wyoming-openwakeword

    # Tools
    vscode
    vlc
    nomacs
    transmission_4-qt6
    sqlitestudio
    solaar
    coppwr
    lmstudio
    qtcreator
    ventoy

    # 3D
    slic3r
    openscad-lsp
    openscad-unstable

    # Python
    pipx
    pyright
    python3
    portaudio
    libpulseaudio

    # Nixos
    nix-output-monitor
    nixd
    nixfmt-classic
    devenv

    # C++
    clang-tools
    cmake
    gnumake
    libclang

    cudatoolkit
    direnv
    egl-wayland
    glslang
    libgdiplus
    logitech-udev-rules
   
    pwvucontrol
    virtualgl
    
    
    catppuccin-sddm
    kdePackages.kdeclarative
    kdePackages.kirigami
    kdePackages.libplasma
    kdePackages.oxygen-icons
    kdePackages.oxygen-sounds
    kdePackages.plasma-sdk
    kdePackages.qt6ct
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtlanguageserver
    kdePackages.qtserialbus
    kdePackages.qtshadertools
    kdePackages.qttools
    kdePackages.qtutilities
    kdePackages.qtwayland
    kdePackages.qtwebengine
    kdePackages.qtwebsockets
    kdePackages.qtwebview   
    kdePackages.sddm
    kdePackages.qtquick3d
    kdePackages.qtquick3dphysics
    kdePackages.qttools
    kdePackages.qmlbox2d
    kdePackages.plasma-browser-integration
    kdePackages.qtmultimedia

    box2d
  ];

  services.printing.drivers = with pkgs; [ splix samsung-unified-linux-driver ];
  services.udev = {
    enable = true;
    extraRules =
      "SUBSYSTEM=='tty', MODE='0666', GROUP='dialout',SYMLINK+='device_%s{serial}'";
  };

  services.flatpak.enable = true;
  # services.cloudflare-warp.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libusb1
    libstdcxx5
    
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  programs.adb.enable = true;
  programs.kdeconnect.enable = true;

  system.stateVersion = "24.05"; 

  
}
