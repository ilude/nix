#!/usr/bin/env bash

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <vm_id> [vm_storage]"
    exit 1
fi

VM_ID=$1
VM_STORAGE=${2:-local-lvm}

if [[ $(qm list | grep -v grep | grep -ci $VM_ID) > 0 ]]; then
  qm stop $VM_ID --skiplock && qm destroy $VM_ID --destroy-unreferenced-disks --purge
fi

qm create $VM_ID --name nixos-23.11-template --memory 2048 --cores 4 --cpu cputype=host
qm set $VM_ID --agent 1 --machine q35 --ostype l26 --onboot 1 --scsihw virtio-scsi-pci 
qm set $VM_ID --net0 virtio,bridge=vmbr0 --ipconfig0 ip=dhcp

DISK_IMAGE=$(find /tmp -maxdepth 1 -name "*.qcow2" -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d' ' -f2-)
qm importdisk $VM_ID $DISK_IMAGE $VM_STORAGE --format raw | grep -v 'transferred'
qm set $VM_ID --scsi0 $(pvesm list $VM_STORAGE | grep "vm-${VM_ID}-disk-0" | awk '{print $1}')

# UEFI GPT Disk
#qm set $VM_ID --bios ovmf --boot order='scsi0;ide2' --efidisk0 $VM_STORAGE:0,pre-enrolled-keys=0,efitype=4m,size=528K 

qm start $VM_ID
