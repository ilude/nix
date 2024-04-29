{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  };

  system.autoUpgrade.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  #time.timeZone = "America/Los_Angeles";

  # Define a user account.
  users.users.anvil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" ];
    shell = pkgs.zsh;
    hashedPassword = "${HASHED_PASSWORD}";
    #packages = with pkgs; [];
  };

  security.sudo.wheelNeedsPassword = false;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  programs = { 
    zsh.enable = true;
    nix-ld.enable = true; 
  };

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Select internationalisation properties.
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.defaultLocale = "en_US.UTF-8";
  environment.variables = {
    TZ = config.time.timeZone;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    cloud-init
    coreutils
    curl
    docker
    docker-buildx
    docker-compose
    eza
    findutils
    fzf
    git
    gnumake
    gnutar
    htop
    iproute2
    jq
    killall
    less
    libuuid
    linuxHeaders
    mkpasswd
    netcat
    nettools
    nmap
    openssl
    python3
    python3Packages.pip
    ripgrep
    rsync
    spice-vdagent
    ssh-import-id
    strace
    sysstat
    tealdeer
    tree
    tzdata
    unzip
    util-linux
    wget
    yq
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  #services.cloud-init.enable = true;
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
