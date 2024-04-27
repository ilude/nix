{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Set your time zone.
  time.timeZone = "America/New_York";
  #time.timeZone = "America/Los_Angeles";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anvil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    password = "";
    #packages = with pkgs; [];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  security.sudo.extraRules= [
  { users = [ "anvil" ];
     commands = [
        { command = "ALL" ;
          options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    coreutils
    docker
    docker-buildx
    docker-compose
    #nvidia-docker
    eza
    findutils
    fzf
    git
    gnumake
    gnutar
    htop
    iproute2
    jq
    less
    libuuid
    linuxHeaders
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
    tree
    tzdata
    util-linux
    wget
    yq
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
