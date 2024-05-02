{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ 
      <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
      ./machine-config.nix
    ];

  system.build.qcow2 = import <nixpkgs/nixos/lib/make-disk-image.nix> {
    inherit lib config;
    pkgs = import <nixpkgs> { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    diskSize = 8192;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix" (pkgs.lib.readFile ./machine-config.nix);
  };
}{ config, lib, pkgs, ... }:

with lib;

let
  secrets = import ./.secrets;

  machineConfig = import ./machine-config.nix {
    inherit pkgs lib;
    secrets = secrets;
  };

  configFile = pkgs.writeText "configuration.nix" ''
    { pkgs, lib, ... }:

    ${builtins.toJSON machineConfig}
  '';
in
{
  imports = (machineConfig.config.imports or []) ++ [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  config = machineConfig.config // {
    system.build.qcow2 = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      inherit lib config;
      pkgs = import <nixpkgs> { inherit (pkgs) system; };
      diskSize = 8192;
      format = "qcow2";
      configFile = configFile;
    };
  };
}