#!/usr/bin/bash -x


/usr/bin/pacman -S --noconfirm  cloud-init

systemctl enable cloud-init-local.service
systemctl enable cloud-init.service
systemctl enable cloud-config.service
systemctl enable cloud-final.service

echo " >>>>>>>>>>>> ${HTTPSRV}"
cp /etc/cloud/cloud.cfg /etc/cloud/cloud.cfg.save
/usr/bin/curl -o /etc/cloud/cloud.cfg http://${HTTPSRV}/cloud/cloud.cfg

mv /tmp/hosts.arch.tmpl /etc/cloud/templates/hosts.arch.tmpl

cat /etc/cloud/cloud.cfg
cat /etc/cloud/templates/hosts.arch.tmpl 
