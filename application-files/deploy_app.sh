#!/bin/bash
# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

sudo apt -y update
sudo apt -y install cowsay unzip git build-essential nodejs curl npm node-grunt-cli

# Clumsy Bird
sudo mkdir /src
git clone https://github.com/ellisonleao/clumsy-bird
sudo cp -r ./clumsy-bird /src/clumsy-bird
sudo chmod +x /src/clumsy-bird/
sudo chown -R ubuntu:ubuntu /src/clumsy-bird/
cd /src/clumsy-bird/
npm install

sudo tee -a /etc/systemd/system/clumsy-bird.service <<EOF
[Install]
WantedBy=multi-user.target

[Unit]
Description=Clumsy Bird App

[Service]
WorkingDirectory=/src/clumsy-bird
ExecStart=grunt connect --gruntfile /src/clumsy-bird/Gruntfile.js -f  >> /var/log/webapp.log
IgnoreSIGPIPE=false
KillMode=process
Restart=on-failure
EOF

sudo systemctl daemon-reload
sudo systemctl start clumsy-bird.service
sudo systemctl enable clumsy-bird.service

cowsay Clumsy Bird!!