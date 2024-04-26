parted /dev/sdb -- mklabel msdos
parted /dev/sdb -- mkpart primary 1MB -8GB
parted /dev/sdb -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sdb1
mkswap -L swap /dev/sdb2
swapon /dev/sdb2
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt

curl -s "https://raw.githubusercontent.com/ilude/nix/main/configuration.nix?$(date +%s)" > /mnt/etc/nixos/configuration.nix
nano /mnt/etc/nixos/configuration.nix
