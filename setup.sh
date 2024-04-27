#!/usr/bin/env bash

set -e
set -x
set -o xtrace

DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"
if [ ! -b "$DEVICE" ]; then
  echo "ERROR: The default disk $DEVICE is missing!"
  exit 1;
fi

# List partitions on the device
PARTITIONS=$(lsblk "$DEVICE" --output NAME --noheadings --raw)

# Check if partitions exist
if [ -n "$PARTITIONS" ]; then
    echo "The device $DEVICE has the following partitions:"
    echo "$PARTITIONS"
else
    parted $DEVICE -- mklabel msdos
    parted $DEVICE -- mkpart primary 1MB -8GB
    parted $DEVICE -- mkpart primary linux-swap -8GB 100%
    
    mkfs.ext4 -L nixos $DEVICE-part1
    mkswap -L swap $DEVICE-part2
    swapon /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part2
    mount /dev/disk/by-label/nixos /mnt
    nixos-generate-config --root /mnt
fi

# Check for a user password 
if [ -z "${PW}" ]; then
    # Prompt the user for a password
    read -p "Enter User password: " -s PW
    echo
fi
# Generate the hashed password
HASHED_PASSWORD=$(mkpasswd "$PW")

# download the configuation.nix template
curl -s "https://raw.githubusercontent.com/ilude/nix/main/configuration.nix?$(date +%s)" > configuration.nix

# process the template
envsubst < configuration.nix > /mnt/etc/nixos/configuration.nix

nixos-install

while true; do
    read -p "Do you want to reboot now? (y/n) " yn
    case $yn in
        [Yy]* )
            reboot
            break;;
        [Nn]* )
            exit;;
        * )
            echo "Please answer y or n.";;
    esac
done
