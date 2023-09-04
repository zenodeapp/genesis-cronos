#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <swapfile_to_remove>"
    echo "   <swapfile_to_remove> is the full path to the swap file you wish to remove."
    exit 1
fi

# Get the provided swap file as an argument
swapfile_to_remove="$1"

# Check if the swap file starts with '/genesisd_swapfile'
if [ "$(echo "$swapfile_to_remove" | cut -c 1-18)" != "/genesisd_swapfile" ]; then
    echo "Error: The specified swap file does not start with '/genesisd_swapfile'."
    exit 1
fi

# Remove the corresponding entry from /etc/fstab
swapfile_name=$(basename "$swapfile_to_remove")
sed -i "/^\/$swapfile_name /d" /etc/fstab
echo "Removed entry for $swapfile_name from /etc/fstab"

# Attempt to disable the swap file
swapoff -v "$swapfile_to_remove"

# Check if the swap file is still listed as active
if swapon --show | grep -q "^$swapfile_to_remove "; then
    echo "Swap file $swapfile_to_remove was not removed because it is still in use."
else
    # Check if the provided swap file exists
    if [ ! -f "$swapfile_to_remove" ]; then
        echo "Error: The specified swap file does not exist."
        exit 1
    fi

    # Remove the swap file
    rm -f "$swapfile_to_remove"
    echo "Removed swap file: $swapfile_to_remove"
fi