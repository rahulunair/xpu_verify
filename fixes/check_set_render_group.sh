#!/bin/bash

render_group="render"

if ! getent group $render_group > /dev/null; then
    sudo groupadd $render_group
fi

regular_users=$(getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1}')

for user in $regular_users; do
    if ! id -nG "$user" | grep -qw $render_group; then
        sudo usermod -aG $render_group $user
        echo "Added $user to $render_group group"
    else
        echo "$user is already in $render_group group"
    fi
done
