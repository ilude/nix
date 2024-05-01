{ config, lib, pkgs, ... }: {
  systemd.services.setupuser = let
    script = lib.getExe (pkgs.writeShellApplication {
      name = "setupuser";
      runtimeInputs = [ pkgs.ssh-import-id pkgs.openssh ];
      text = ''
        ssh-import-id gh:ilude
        touch ~/.zshrc
      '';
    });
  in {
    description = "Import SSH key from GitHub";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "anvil";
      Type = "oneshot";
      ExecStart = "${script}";
    };
  };
}