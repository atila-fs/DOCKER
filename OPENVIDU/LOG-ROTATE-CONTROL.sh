# Criar arquivo no path: /etc/logrotate.d/openvidu
# Depois rodar: sudo systemctl restart rsyslog

/var/log/openvidu-server.log
/var/log/kms.log
/var/log/coturn.log
/var/log/openvidu-nginx.log {
  daily
  rotate 14
  compress
  missingok
  notifempty
  create 0640 syslog adm
  sharedscripts
  postrotate
    systemctl reload rsyslog >/dev/null 2>&1 || true
  endscript
}