{ pkgs, lib, ... }: let
  # Import the secrets.nix file
  secrets = import ./.secrets;
in {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };

    system.autoUpgrade.enable = true;

    # Reference the username and password from secrets.nix
    users.users."${secrets.user.username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "systemd-journal" ];
      shell = pkgs.zsh;
      hashedPassword = "${secrets.user.password}";
    };

    # Set the root's hashed password from secrets.nix
    users.extraUsers.root = {
      hashedPassword = "${secrets.root.password}";
    };

    security.sudo.wheelNeedsPassword = false;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = [ pkgs.zsh ];

    programs = {
      zsh.enable = true;
      nix-ld.enable = true;
    };

    networking.enableIPv6 = false;
    i18n.defaultLocale = "en_US.UTF-8";

    services.openssh.enable = true;
    services.qemuGuest.enable = true;
    virtualisation.docker.enable = true;

    # Set your time zone.
    time.timeZone = "America/New_York";
    environment.variables.TZ = "America/New_York";

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
      just
      killall
      less
      libuuid
      linuxHeaders
      mkpasswd
      netcat
      nettools
      nixfmt
      nixpkgs-fmt
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
      zsh
      zsh-fzf-tab
      zsh-completions
      zsh-autosuggestions
      nix-zsh-completions
      zsh-syntax-highlighting
    ];
  };
}
