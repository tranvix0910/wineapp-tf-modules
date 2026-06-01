#!/bin/bash
MONGO_VERSION="8.0"

sudo apt-get install -y gnupg curl

curl -fsSL "https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc" | \
   sudo gpg -o "/usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg" \
   --dearmor --yes

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/${MONGO_VERSION} multiverse" | \
   sudo tee "/etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list"

sudo apt-get update

sudo apt-get install -y mongodb-mongosh
