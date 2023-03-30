#!/bin/bash

local_repo_removed=0
backup_dir="/tmp/local_repo_backups"

mkdir -p "$backup_dir"

for file in /etc/apt/sources.list /etc/apt/sources.list.d/*; do
    if [ -f "$file" ]; then
        if grep -q "deb \[arch=amd64\] file:/var/local-repo" "$file"; then
            local_repo_removed=1
            backup_file="${backup_dir}/$(basename "$file")_$(date +%Y%m%d_%H%M%S).bak"
            cp "$file" "$backup_file"
            echo "Removing local repository from $file and creating backup: $backup_file"
            sed -i '/deb \[arch=amd64\] file:\/var\/local-repo/d' "$file"
        fi
    fi
done

if [ $local_repo_removed -eq 1 ]; then
    echo "Updating package list..."
    sudo -E apt-get update
else
    echo "No local repositories were found or removed. Skipping update."
fi
