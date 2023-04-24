render_group="render"
exclude_users="nogroup"

if ! getent group $render_group > /dev/null; then
    echo "Render group not found on this system..."
    exit 1
fi

regular_users=$(getent passwd | awk -F: -v exclude_uids="65534" '$3 >= 1000 && $3 != 65534 && !($1 in exclude_uids) {print $1}')
if [ -z "$(echo "$regular_users" | xargs -n1 id -nG | grep -v render | sort -u)" ]; then
    echo "All users with UID >= 1000 are in render group"
    exit 0
else
    echo "Users not in render group:"
    echo "$regular_users" | xargs -n1 id -nG | grep -v render | sort -u
    exit 1
fi
