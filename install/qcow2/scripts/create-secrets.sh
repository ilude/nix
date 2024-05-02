#!/usr/bin/env bash

if [ ! -f ".secrets" ]; then
  read -p "Enter your desired username: " -r username
  while true; do
    read -s -p "Enter your password: " -r password
    read -s -p "Confirm your password: " -r password_confirm
    if [ "$password" = "$password_confirm" ]; then
      break
    else
      echo "Passwords do not match. Please try again."
    fi
  done
  hashed_password=$(mkpasswd "$password")
  while true; do
    read -s -p "Enter your root password: " -r root_password
    read -s -p "Confirm your root password: " -r root_password_confirm
    if [ "$root_password" = "$root_password_confirm" ]; then
      break
    else
      echo "Passwords do not match. Please try again."
    fi
  done
  hashed_root_password=$(mkpasswd "$root_password")
  echo "{ \
    user = { \
      username = \"$username\"; \
      password = \"$hashed_password\"; \
    }; \
    root = { \
      password = \"$hashed_root_password\"; \
    }; \
  }" > secrets.nix
  nixfmt secrets.nix
  mv secrets.nix .secrets
fi