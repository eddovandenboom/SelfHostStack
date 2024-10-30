#!/bin/bash

# To controll script output
exec > install.log 2>&1
exec 3>/dev/tty

info() {
  message=$1
  echo -e "$message ..." >&3
}

# Stop after error
set -e

info "Reading environment variables from .env"
export $(grep -v '^#' .env | xargs)

info "Removing SSH key from known hosts (if present)"
ssh-keygen -R $SERVER_IP

info "Adding user"
envsubst < add_user.sh | ssh -o StrictHostKeyChecking=no root@$SERVER_IP 'bash -s'

info "Copying files"
envsubst < caddy/Caddyfile.template > caddy/Caddyfile
ssh $NEW_USER@$SERVER_IP "mkdir -p /home/$NEW_USER/caddy"
scp caddy/{Caddyfile,compose.yaml} $NEW_USER@$SERVER_IP:/home/$NEW_USER/caddy/

info "Running setup script on remote server (this may take a while)"
envsubst < server.sh | ssh $NEW_USER@$SERVER_IP 'bash -s'

info "Updating local SSH config"
cat <<EOL >> "$HOME/.ssh/config"
Host $SSH_CONFIG_HOST
  HostName $SERVER_IP
  User $NEW_USER
EOL

info "
Post installation steps:
1. Add A record to DNS records of $DOMAIN_NAME. Name: *, Data: $SERVER_IP
2. Go to portainer.$DOMAIN_NAME to setup Portainer
3. In Portainer, go to Settings-->General, and add the following link in App Templates:
https://raw.githubusercontent.com/Lissy93/portainer-templates/main/templates.json

(for more info: see https://github.com/Lissy93/portainer-templates)"