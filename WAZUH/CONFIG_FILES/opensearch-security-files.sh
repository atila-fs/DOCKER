#!/bin/bash
sudo touch /opt/wazuh/config/opensearch-security/action_groups.yml
sudo touch /opt/wazuh/config/opensearch-security/roles.yml
sudo touch /opt/wazuh/config/opensearch-security/tenants.yml
sudo touch /opt/wazuh/config/opensearch-security/nodes_dn.yml
sudo touch /opt/wazuh/config/opensearch-security/whitelist.yml
sudo touch /opt/wazuh/config/opensearch-security/allowlist.yml
sudo touch /opt/wazuh/config/opensearch-security/audit.yml
sudo chown -R 1000:1000 /opt/wazuh/config/opensearch-security