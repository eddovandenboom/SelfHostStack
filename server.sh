#!/bin/bash

# Exit on error
set -e

# Add temporary passwordless sudo access for new user
echo ${USER_PASSWORD} | sudo -S bash -c "echo \"$NEW_USER ALL=(ALL) NOPASSWD:ALL\" > \"$TEMP_SUDOERS\""

# Disable SSH message of the day
sudo sed -i '/pam_motd\.so/ s/^/# /' /etc/pam.d/sshd

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install brew and add to path
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> /home/ubuntu/.zshrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ubuntu/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install python
brew install python
path+=($(brew --prefix python)/libexec/bin)

# Install pipx
brew install --include-deps pipx

# Ensure applications added via pipx are in PATH
pipx ensurepath

# Add shell completions for pipx (as recommended in docs)
pipx install argcomplete
autoload -U compinit && compinit
eval "$(register-python-argcomplete pipx)"

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sudo ./get-docker.sh

# Create Docker network
docker network create caddy_net

# Set up Caddy
docker compose -f /home/${NEW_USER}/caddy/compose.yaml up -d

# Install and run Portainer using Docker
docker volume create portainer_data
docker run -d --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data --network caddy_net portainer/portainer-ce:2.21.4

# Remove temporary passwordless sudo access
sudo rm "$TEMP_SUDOERS"