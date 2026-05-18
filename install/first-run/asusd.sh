sudo mkdir -p /etc/asusd
sudo systemctl reset-failed asusd.service
sudo systemctl restart asusd.service

asusctl battery limit 80