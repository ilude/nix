parted /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0 -- mklabel msdos
parted /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0 -- mkpart primary 1MB -8GB
parted /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0 -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part1
mkswap -L swap /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part2
swapon /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part2
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt

curl -s "https://raw.githubusercontent.com/ilude/nix/main/configuration.nix?$(date +%s)" > /mnt/etc/nixos/configuration.nix
nano /mnt/etc/nixos/configuration.nix
