### Proxmox

#### Download nixos minimal iso into lvm-local

```
URL="https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso"
# Get the filename from the URL
FILENAME="${URL##*/}"
LOCAL_IMAGE=/var/lib/vz/template/iso/$FILENAME
if [[ ! -f $LOCAL_IMAGE ]]; then 
   echo "downloading nixos iso..."
   curl -s https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso > $LOCAL_IMAGE
fi

if [[ $(qm list | grep -v grep | grep -ci ${VM_ID:-8000}) > 0 ]]; then
  qm stop ${VM_ID:-8000} --skiplock && qm destroy ${VM_ID:-8000} --destroy-unreferenced-disks --purge
fi
qm create ${VM_ID:-8000} --name nixos-test --memory 2048 --cores 4 --cpu cputype=host --machine q35 --bios seabios --ostype l26 --onboot 1 --net0 virtio,bridge=vmbr0 -ipconfig0 ip=dhcp 
qm set ${VM_ID:-8000} --cdrom local:iso/$FILENAME 
qm set ${VM_ID:-8000} --scsi0 ${VM_STORAGE:-local-lvm}:32
qm set ${VM_ID:-8000} --agent enabled=1,type=virtio,fstrim_cloned_disks=1 --localtime 1
qm start ${VM_ID:-8000}
```

### Install in the VM console
```
sudo -i
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
swapon /dev/sda2
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt

nano /mnt/etc/nixos/configuration.nix

nixos-install
reboot
```


### notes

```
nix-shell -p curl
curl https://t.ly/_c10E >> setup
bash setup
```

