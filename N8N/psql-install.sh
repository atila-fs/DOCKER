#!/bin/bash
set -e
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget curl ca-certificates gnupg lsb-release
echo "🔧 Adicionando repositório oficial do PostgreSQL..."
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/pgdg.gpg
sudo apt update -y
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
psql --version
sudo systemctl status postgresql --no-pager