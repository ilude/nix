### Proxmox

#### Download nixos minimal iso into lvm-local

```
URL="https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso"
FILENAME="${URL##*/}"
LOCAL_IMAGE=/var/lib/vz/template/iso/$FILENAME
if [[ ! -f $LOCAL_IMAGE ]]; then 
   echo "downloading nixos iso..."
   curl -s $URL > $LOCAL_IMAGE
fi

if [[ $(qm list | grep -v grep | grep -ci ${VM_ID:-8000}) > 0 ]]; then
  qm stop ${VM_ID:-8000} --skiplock && qm destroy ${VM_ID:-8000} --destroy-unreferenced-disks --purge
fi
qm create ${VM_ID:-8000} --name nixos-test --memory 2048 --cores 4 --cpu cputype=host --machine q35 --bios seabios --ostype l26 --onboot 1
qm set ${VM_ID:-8000} --net0 virtio,bridge=vmbr0 -ipconfig0 ip=dhcp
qm set ${VM_ID:-8000} --scsi0 ${VM_STORAGE:-local-lvm}:32
qm set ${VM_ID:-8000} --ide2 local:iso/$FILENAME 
qm set ${VM_ID:-8000} --boot order='scsi0;ide2'
qm set ${VM_ID:-8000} --agent enabled=1,type=virtio,fstrim_cloned_disks=1 --localtime 1
qm start ${VM_ID:-8000}

```

### Install in the VM console
```
sudo -i
nix-shell -p curl
curl -L https://t.ly/_c10E > setup
bash -x setup

nixos-install
reboot
```
