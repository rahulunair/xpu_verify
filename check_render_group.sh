render_group="render"

if ! getent group $render_group > /dev/null; then
    echo "Render group not found on this system..."
    exit 1
fi

regular_users=$(getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1}')

if [ -z "$(getent passwd | awk -F: '$3 >= 1000 {print $1}' | xargs -n1 id -nG | grep -v render | sort -u)" ]; then
    echo "All users with UUID > 1000 are in render group"
    exit 0
else
    echo "Users not in render group:"
    getent passwd | awk -F: '$3 >= 1000 {print $1}' | xargs -n1 id -nG | grep -v render | sort -u
    exit 1
fi

