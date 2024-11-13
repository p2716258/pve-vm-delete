#!/bin/bash

# Check if the user has the necessary permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo." 
   exit 1
fi

# List VMs and store the output
echo "Listing all VMs:"
vm_list=$(qm list)

# Extract VM IDs from the output (skipping the header)
vm_ids=$(echo "$vm_list" | awk 'NR>1 {print $1}')

# Iterate through each VM ID
for vmid in $vm_ids; do
    # Confirm deletion
    read -p "Are you sure you want to delete VM ID $vmid? This action cannot be undone (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        echo "VM ID $vmid deletion cancelled."
        continue
    fi

    # Delete the VM
    echo "Deleting VM ID $vmid..."
    qm destroy "$vmid" --purge --destroy-unreferenced-disks

    # Check the result of the deletion command
    if [[ $? -eq 0 ]]; then
        echo "VM ID $vmid has been successfully deleted."
    else
        echo "Failed to delete VM ID $vmid. Please check the logs for more information."
    fi
done