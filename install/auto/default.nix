{
	system ? "x86_64-linux",
}:
(import <nixpkgs/nixos/lib/eval-config.nix> {
	inherit system;
	modules = [
		<nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
		./configuration.nix
		({ config, pkgs, lib, ... }: {
			systemd.services.install = {
				description = "Bootstrap a NixOS installation";
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" "polkit.service" ];
				path = [ "/run/current-system/sw/" ];
				script = with pkgs; ''
					echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history

					set -eux

					wait-for() {
						for _ in seq 10; do
							if $@; then
								break
							fi
							sleep 1
						done
					}

					DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"
					if [ ! -b "$DEVICE" ]; then
						echo "ERROR: The default disk $DEVICE is missing!"
						exit 1;
					fi

					# List partitions on the device
					PARTITIONS=$(lsblk "$DEVICE" --output NAME --noheadings --raw | wc -l)

					# Check if partitions exist
					if [ "$PARTITIONS" != 1 ]; then
							echo "Looks like the disk partitions are already setup, skipping this step!"
					else
							parted $DEVICE -- mklabel gpt
							parted $DEVICE -- mkpart root ext4 512MB 100%
							parted $DEVICE -- mkpart ESP fat32 1MB 512MB
							parted $DEVICE -- set 2 esp on

							sync

							mkfs.ext4 -L nixos /dev/disk/by-partlabel/root
							mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/ESP 

							sync
							
							mount /dev/disk/by-label/nixos /mnt

							mkdir -p /mnt/boot
							mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
					fi

					# nixos-generate-config --root /mnt

					install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
					install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

					sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

					${config.system.build.nixos-install}/bin/nixos-install \
						--system ${(import <nixpkgs/nixos/lib/eval-config.nix> {
							inherit system;
							modules = [
								./configuration.nix
								./hardware-configuration.nix
							];
						}).config.system.build.toplevel} \
						--no-root-passwd \
						--cores 0

					touch /home/nixos/.zshrc
					touch /root/.zshrc

					date +"%Y-%m-%d %H:%M" > /mnt/etc/birth-certificatte
					echo "System build complete, rebooting now!"
					${systemd}/bin/shutdown -r now "System build complete, rebooting now!"
				'';
				environment = config.nix.envVars // {
					inherit (config.environment.sessionVariables) NIX_PATH;
					HOME = "/root";
				};
				serviceConfig = {
					Type = "oneshot";
				};
			};
		})
	];
}).config.system.build.isoImage
