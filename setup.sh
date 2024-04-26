parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
swapon /dev/sda2
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt

curl -s "https://raw.githubusercontent.com/ilude/nix/main/configuration.nix?$(date +%s)" > /mnt/etc/nixos/configuration.nix
nano /mnt/etc/nixos/configuration.nix
