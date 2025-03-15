# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Enable OpenGL - https://nixos.wiki/wiki/Nvidia
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # https://nixos.wiki/wiki/Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {

    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the KDE/Wayland Desktop Environment. https://discourse.nixos.org/t/replacing-x11-with-wayland-on-kde-plasma-6/58650
    # displayManager.sddm.enable = true;
    # displayManager.sddm.wayland.enable = true;
    # displayManager.sddm.settings.General.DisplayServer = "wayland";
    # desktopManager.plasma6.enable = true;



    # Configure keymap in X11
    xserver.xkb = {
        layout = "br";
        variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
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

  xserver.videoDrivers = [ "nvidia" ];

  ollama = {
    enable = true;
    # Optional: load models on startup
    # loadModels = [ ... ];

    acceleration = "cuda";
  };

  # radicle.enable = true;

  # Enable automatic login for the user.
  displayManager.autoLogin.enable = true;
  displayManager.autoLogin.user = "lbbombardelli";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  flatpak.enable = true;


  # Enable the OpenSSH daemon.
  openssh.enable = true;
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lbbombardelli = {
    isNormalUser = true;
    description = "Leonardo Bombardelli";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # stylix - https://www.youtube.com/watch?v=ljHkWgBaQWU
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.image = ./de-wallpaper.jpg;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Programs
  programs = {
    # Install firefox.
    firefox.enable = true;

    # Activates niri
    niri = {
      enable = true;
      };

    # https://discourse.nixos.org/t/how-to-do-xwayland-on-nixos/57825
    xwayland.enable = true;

    zsh = {
      # Enables Zshell
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl" ];
      };
      shellAliases = {
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";

        lg = "lazygit";
        ld = "sudo lazydocker";
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

    niri
    waybar
    mako
    fuzzel
    alacritty
    xwayland-satellite

    wget
    git
    lazygit
    jujutsu
    unstable.lazyjj
    htop
    vscode
    radicle-node
    radicle-explorer
    gnome-tweaks
    unstable.zed-editor
    unstable.firefox

    stremio
    signal-desktop
    discord-ptb
    ledger
    obsidian
    zotero

    go
    gcc
    rustup
    python314Full
    python313Full
    unstable.python313Packages.black
    unstable.python313Packages.ruff
    unstable.python313Packages.pylint
    unstable.python313Packages.pip
    uv
    nil
    docker
    lazydocker
    bruno
    nixd
  ];

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
