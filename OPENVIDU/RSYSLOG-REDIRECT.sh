# Criar arquivo no path: /etc/rsyslog.d/30-docker-openvidu.conf
# Depois rodar: sudo systemctl restart rsyslog

# openvidu-server
if ($programname == "openvidu-server") or ($syslogtag contains "openvidu-server") then {
  action(type="omfile" file="/var/log/openvidu-server.log" createDirs="on")
  stop
}

# kms (Kurento)
if ($programname == "kms") or ($syslogtag contains "kms") then {
  action(type="omfile" file="/var/log/kms.log" createDirs="on")
  stop
}

# coturn
if ($programname == "coturn") or ($syslogtag contains "coturn") then {
  action(type="omfile" file="/var/log/coturn.log" createDirs="on")
  stop
}

# nginx do OpenVidu
if ($programname == "openvidu-nginx") or ($syslogtag contains "openvidu-nginx") then {
  action(type="omfile" file="/var/log/openvidu-nginx.log" createDirs="on")
  stop
}