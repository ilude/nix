#!/usr/bin/env bash

set -ex

if [[ $(qm list | grep -v grep | grep -ci ${VM_ID:-8500}) > 0 ]]; then
  qm stop ${VM_ID:-8500} --skiplock && qm destroy ${VM_ID:-8500} --destroy-unreferenced-disks --purge
fi
qm create ${VM_ID:-8500} --name nixos-23.11-template --memory 2048 --cores 4 --cpu cputype=host
qm set ${VM_ID:-8500} --agent 1 --machine q35 --ostype l26 --onboot 1 --scsihw virtio-scsi-pci 
qm set ${VM_ID:-8500} --net0 virtio,bridge=vmbr0 --ipconfig0 ip=dhcp

DISK_IMAGE=$(find /tmp -maxdepth 1 -name "*.qcow2" -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d' ' -f2-)
qm importdisk ${VM_ID:-8500} ${DISK_IMAGE} ${VM_STORAGE:-local-lvm} --format raw | grep -v 'transferred'
qm set ${VM_ID:-8500} --scsi0 $(pvesm list ${VM_STORAGE:-local-lvm} | grep "vm-${VM_ID:-8500}-disk-0" | awk '{print $1}')

# UEFI GPT Disk
#qm set ${VM_ID:-8500} --bios ovmf --boot order='scsi0;ide2' --efidisk0 ${VM_STORAGE:-local-lvm}:0,pre-enrolled-keys=0,efitype=4m,size=528K 

qm start ${VM_ID:-8500}

# echo "cleaning up old img files..."
# ls -t /tmp/nixos-*.img | tail -n +6 | xargs rm
