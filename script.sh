#!/bin/bash

# Check if the user has the necessary permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo." 
   exit 1
fi

# List VMs
echo "Listing all VMs:"
qm list

# Prompt user for VM ID
read -p "Enter the VM ID to delete: " vmid

# Validate that the input is a number
if ! [[ "$vmid" =~ ^[0-9]+$ ]]; then
    echo "Invalid VM ID. Please enter a numeric value."
    exit 1
fi

# Confirm deletion
read -p "Are you sure you want to delete VM ID $vmid? This action cannot be undone (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "VM deletion cancelled."
    exit 0
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