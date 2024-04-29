{ config, pkgs, ... }: {
	boot.loader.systemd-boot.enable = true;

	fileSystems."/boot" = {
		device = "/dev/disk/by-partlabel/ESP";
		fsType = "vfat";
	};

	fileSystems."/" = {
		device = "/dev/disk/by-partlabel/root";
		fsType = "ext4";
	};
}