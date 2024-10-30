set -e

# Create non-root user and add SSH access
useradd -m -s /bin/bash -G sudo $NEW_USER && echo "$NEW_USER:$USER_PASSWORD" | chpasswd
rsync --archive --chown=$NEW_USER:$NEW_USER ~/.ssh /home/$NEW_USER

groupadd docker
usermod -aG docker $NEW_USER

# Disable root SSH login
# TODO: disable login with password
sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh