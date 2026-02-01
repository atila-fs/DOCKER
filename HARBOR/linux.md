mkdir -p /opt/certs /opt/projetos-ops/harbor
cd /opt/projetos-ops/harbor
wget https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-online-installer-v2.10.0.tgz
tar xvf harbor-online-installer-v2.10.0.tgz
cp harbor.yml.tmpl harbor.yml
vim harbor.yml  # edita as configs deixa igual o sample que esta no repositorio
./install.sh

OBS: Os certificados tem que ficar em /opt/certs com o nome igual o do sample e com a chave privada descriptada!