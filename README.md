## Goal
Setup a cloud server with caddy (reverse proxy, so that https is used), Docker (containerization, so that apps are well separated) and Portainer (web app to manage Docker containers) with a lot of templates for 1-click apps so that you can easily self-host your own apps in the cloud (e.g. Nextcloud, VaultWarden, Wordpress, Home Assistant, Immich, N8N, LibreChat, or your own software)

## Instructions
- If you don't have a domain name yet, create one using a domain name registrar (~€10 per year)

- If you don't have an SSH key yet on your PC, generate it using ssh-keygen

- Create a cloud server at a cloud provider of your choice with the latest version of Ubuntu. Make sure to add the SSH key of your PC for access. **Assumtpion:** SSH access is granted for user `root` (check documentation of cloud provider). Save the IPv4 address of the server that you created (~€10 per month). The server size depends on your use case (the apps that you want to host and the number of apps). I use a cloud server with 8GB RAM, this allows me to run a lot of apps quite comfortably.

- Create .env file and set environment variables
    - SSH_CONFIG_HOST: later you will be able to access your server via the terminal using ssh ***
    - DOMAIN_NAME: the domain name you registered and want to use for your server
    - NEW_USER: the name of the new user that is added on the server
    - USER_PASSWORD: the password of the new user. Save it well

- Run script `install.sh` locally to setup the server

- Add portainer one-click templates: following instructions in https://github.com/Lissy93/portainer-templates