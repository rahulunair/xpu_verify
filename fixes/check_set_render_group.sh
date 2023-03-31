#!/bin/bash

render_group="render"
current_user=$(whoami)

if ! getent group $render_group > /dev/null; then
    echo "Render group not found on this system..."
    exit 1
fi

if id -nG "$current_user" | grep -qw "$render_group"; then
    echo "Current user ($current_user) is already in the render group"
    exit 0
else
    echo "Current user ($current_user) is not in the render group, adding..."
    sudo usermod -a -G $render_group $current_user
    if [ $? -eq 0 ]; then
        echo "Current user ($current_user) has been added to the render group"
        exit 0
    else
        echo "Failed to add current user ($current_user) to the render group"
        exit 1
    fi
fi

#render_group="render"
#if ! getent group $render_group > /dev/null; then
#    sudo groupadd $render_group
#fi
#
#regular_users=$(getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1}')
#
#for user in $regular_users; do
#    if ! id -nG "$user" | grep -qw $render_group; then
#        sudo usermod -aG $render_group $user
#        echo "Added $user to $render_group group"
#    else
#        echo "$user is already in $render_group group"
#    fi
#done
#!/bin/bash
