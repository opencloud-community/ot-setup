#!/bin/bash

# a simple shell script, to quickly generate commonly used config options

if type "pwgen" > /dev/null; then
  echo "###---> Common variables"
  # prit hostname
  echo "# Domain name on wich you want to access the frontend"
  echo "OT_DOMAIN=$(hostnamectl hostname)"
  # gen secrets for postgresm keycloak admin and keycloak client
  echo -e "\nPOSTGRES_PASSWORD=$(pwgen 24)\nKEYCLOAK_ADMIN_PASSWORD=$(pwgen 24)\nKC_CLIENT_SECRET=$(pwgen 24) \n"
  # print ip adresses to use for rabbitmq connection
  echo "# If janus is running in docker host mode it needs a local host interface for rabbitmq to connect."
  echo "# Use only a SINGE line/interface and uncomment it."
  echo "# !!! DO NOT CHOOSE YOUR PUBLIC IP ADDRESS!!!"
  for IP in $(ip -o -4 addr show | awk '{ split($4, ip_addr, "/"); print ip_addr[1] }'| grep -v '127.0.0.1'); do
     echo "# RABBITMQ_HOST=${IP}"
  done
  echo "###<---"
else
  echo "the utility 'pwgen' needs to be installed."
  exit 1  
fi