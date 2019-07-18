#!/bin/bash

echo "****************************************************"
echo "Creating timelapse-pi service"
echo "****************************************************"

cat > /etc/systemd/system/timelapse-pi.service <<'EOF'
[Unit]
Description=Raspistill Timelapse
After=syslog.target
[Service]
ExecStart=/home/pi/timelapse.sh
Restart=on-failure
KillSignal=SIGINT
# log output to syslog as ''
SyslogIdentifier=timelapse-pi
StandardOutput=syslog
# non-root user to run as
WorkingDirectory=/home/pi/
User=pi
Group=pi
[Install]
WantedBy=multi-user.target
EOF


cat > /home/pi/timelapse.sh <<'EOF'
#!/bin/bash
#raspistill -t 43200000 -tl 20000 -o /media/pi/NOX/image%06d.jpg
sleep 30
while :
do
  DATE=$(date +"%Y-%m-%d_%H%M%S")
  raspistill -vf -hf -o /media/pi/NOX/timelapse/$DATE.jpg
  sleep 30
done
EOF

sudo chmod +x /home/pi/timelapse.sh

sudo systemctl daemon-reload 
sudo systemctl enable timelapse-pi.service
sudo systemctl start timelapse-pi.service

echo "****************************************************"
echo "DONE !"
echo "****************************************************"

sudo systemctl status timelapse-pi.service
