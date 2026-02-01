#!/bin/bash

sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-graylog.conf
sudo mkdir -p /opt/projects-ops/graylog/mongo_data
sudo mkdir -p /opt/projects-ops/graylog/os_data
sudo mkdir -p /opt/projects-ops/graylog/graylog_journal
sudo chown -R 999:999 /opt/projects-ops/graylog/mongo_data
sudo chown -R 1000:1000 /opt/projects-ops/graylog/os_data
sudo chown -R 1100:1100 /opt/projects-ops/graylog/graylog_journal
sudo chmod 770 /opt/projects-ops/graylog/graylog_journal