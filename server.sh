#!/bin/bash

# Exit on error
set -e

shopt -s expand_aliases
alias please="echo ${USER_PASSWORD} | sudo -S"

# Update server
please apt-get update -y && please apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
please ./get-docker.sh

# Create Docker network
docker network create caddy_net

# Set up Caddy
docker compose -f /home/${NEW_USER}/caddy/compose.yaml up -d

# Install and run Portainer using Docker
docker volume create portainer_data
docker run -d --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data --network caddy_net portainer/portainer-ce:2.21.4