#!/usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ssh_host> <ssh_command>"
    exit 1
fi

# Extract the hostname from the SSH host
HOSTNAME=$(echo "$1" | cut -d "@" -f 2)

# Prompt user for confirmation
echo -e "\033[1;33mWARNING:\033[0;31m Running this command will destroy and create VM 8500 on $HOSTNAME.\033[0m"
read -p "Are you sure you want to do this? (y/n): " choice
case "$choice" in 
  y|Y ) 
    echo -e "\033[1;35mFuck it, We'll do it LIVE!\033[0m"
    ssh "$1" "$2"
    ;;
  * ) 
    echo "Action canceled."
    ;;
esac
