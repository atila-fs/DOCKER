################ WAZUH ####################
server {
    listen 443 ssl http2;
    server_name wazuh.<valid_domain>;

    ssl_certificate     /etc/nginx/ssl/crt.crt;
    ssl_certificate_key /etc/nginx/ssl/ckey.key;

    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        proxy_pass http://127.0.0.1:5602;
        proxy_http_version 1.1;
        proxy_read_timeout 300;
    }
}