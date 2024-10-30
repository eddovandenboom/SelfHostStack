# TODO: responsive waiting...
create_server() {

  # Check if server with given name already exists
  if hcloud server describe $SERVER_NAME > /dev/null 2>&1 ; then
    read -p "Server $SERVER_NAME already exists. Are you sure you want to delete this server? (y/n): " choice
    [[ "$choice" =~ ^[yY]$ ]] || { echo "Operation aborted."; exit 1; }

    hcloud server delete $SERVER_NAME && echo "Deleted server $SERVER_NAME"
  fi

  echo "Creating $SERVER_NAME"
  ssh_key=$(cat ~/.ssh/id_rsa.pub)
  server=$(hcloud server create --name $SERVER_NAME --type $SERVER_TYPE --image $SERVER_IMAGE --ssh-key $SSH_KEY_NAME)
  export SERVER_IP=$(echo $server | choose 4)

  echo "Waiting some time before conneting with ssh"
  sleep 30
}
