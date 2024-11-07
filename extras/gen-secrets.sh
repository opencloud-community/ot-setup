#!/bin/bash

# a simple shell script, to quickly generate some secrets to place in .env file
if type "pwgen" > /dev/null; then
  echo "POSTGRES_PASSWORD=$(pwgen -s 32 1)"
  echo "KEYCLOAK_ADMIN_PASSWORD=$(pwgen -s 32 1)"
  echo "KEYCLOAK_CLIENT_SECRET_CONTROLLER=$(pwgen -s 32 1)"
  echo "KEYCLOAK_CLIENT_SECRET_OBELISK=$(pwgen -s 32 1)"
  echo "KEYCLOAK_CLIENT_SECRET_RECORDER=$(pwgen -s 32 1)"
  echo "SPACEDECK_API_TOKEN=$(pwgen -s 32 1)"
  echo "SPACEDECK_INVITE_CODE=$(pwgen -s 32 1)"
  echo "ETHERPAD_API_KEY=$(pwgen -s 32 1)"
  echo "LIVEKIT_KEYS_API_SECRET=$(pwgen -s 32 1)"
else
  echo "the utility 'pwgen' needs to be installed."
  exit 1  
fi