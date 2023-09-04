#!/bin/bash

# List all files in the root directory starting with "/genesisd_swapfile"
files_to_remove=$(find / -maxdepth 1 -type f -name 'genesisd_swapfile*')

# Check if there are any files to remove
if [ -z "$files_to_remove" ]; then
    echo "No swap files starting with '/genesisd_swapfile' found in the root directory."
else
    # Iterate through each swap file, disable it, and then remove it
    for file in $files_to_remove; do
        # Attempt to disable the swap file
        swapoff -v "$file"

        # Check if the swap file is still listed as active
        if swapon --show | grep -q "^$file "; then
            echo "Swap file $file was not removed because it is still in use."
        else
            # Remove the swap file
            rm -f "$file"
            echo "Removed swap file: $file"
        fi
    done
fi

 # Remove entries related to these swap files from /etc/fstab
for file in $files_to_remove; do
    # Extract the swap file's name (e.g., genesisd_swapfile)
    swapfile_name=$(basename "$file")

    # Remove the corresponding line from /etc/fstab
    sed -i "/^\/$swapfile_name /d" /etc/fstab
    echo "Removed entry for $swapfile_name from /etc/fstab"
done