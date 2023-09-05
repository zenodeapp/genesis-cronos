#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <swap_size_in_gb>"
    echo "   <swap_size_in_gb> should be the desired size of the swap file in gigabytes (GB)."
    exit 1
fi

swap_size_in_gb="$1"

# Validate that the argument is a positive integer
if ! expr "$swap_size_in_gb" : '^[0-9]\+$' > /dev/null; then
    echo "Error: <swap_size_in_gb> must be a positive integer."
    exit 1
fi

available_disk_gb=$(df -BG --output=avail / | awk 'NR==2 {print $1}' | tr -d 'G')
if [ "$available_disk_gb" -lt "$((swap_size_in_gb))" ]; then
    echo "Sorry, you don't have enough space."
    exit 1
fi

echo "Adding ${swap_size_in_gb}GB of swap space..."

# Find a suitable name for the new swap file
index=2
new_swapfile="/genesisd_swapfile"
while [ -e $new_swapfile ]; do
    new_swapfile="/genesisd_swapfile_$index"
    index=$((index + 1))
done

# Create new swap file
fallocate -l ${swap_size_in_gb}G $new_swapfile
chmod 600 $new_swapfile
mkswap $new_swapfile
swapon $new_swapfile

echo "Additional ${swap_size_in_gb}GB of swap space added in $new_swapfile."

# Add entry to /etc/fstab to make swapfile persistent
line="$new_swapfile none swap sw 0 0"
file=/etc/fstab
if ! grep -qF "$line" "$file"; then
    echo "$line" | sudo tee -a "$file" > /dev/null
    echo "Line '$line' added to $file."
else
    echo "Line '$line' already exists in $file."
fi
