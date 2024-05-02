#!/usr/bin/env bash
set -e

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 [-y] <ssh_host> <ssh_command>"
  exit 1
fi

# Check if the -y flag is provided
if [ "$1" == "-y" ]; then
  SKIP_CONFIRM=true
  shift
else
  SKIP_CONFIRM=false
fi

# Extract the hostname from the SSH host
HOSTNAME=$(echo "$1" | cut -d "@" -f 2)

# Prompt user for confirmation if -y flag is not provided
if [ "$SKIP_CONFIRM" = false ]; then
  echo -e "\\033[1;33mWARNING:\\033[0;31m Running this command will destroy and create VM 8500 on $HOSTNAME.\\033[0m"
  read -p "Are you sure you want to do this? (y/n): " choice
  case "$choice" in
    y|Y )
      echo -e "\\033[1;35mFuck it, We'll do it LIVE!\\033[0m"
      ;;
    * )
      echo "Action canceled."
      exit 0
      ;;
  esac
else
  echo -e "\\033[1;35mFuck it, We'll do it LIVE!\\033[0m"
fi

ssh "$1" "$2"