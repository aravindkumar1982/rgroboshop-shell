#Install GoLang

yum install golang -y

#Configure the application.
#INFO
#Our application developed by the developer of our org and it is not having any RPM software just like other softwares. So we need to configure every step manually
#RECAP
#We already discussed in Linux basics section that applications should run as nonroot user.
#Add application User

useradd roboshop

#INFO
#User roboshop is a function / daemon user to run the application. Apart from that we dont use this user to login to server.
#Also, username roboshop has been picked because it more suits to our project name.
#
#INFO
#We keep application in one standard location. This is a usual practice that runs in the organization.
#Lets setup an app directory.

mkdir /app

Download the application code to created app directory.
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

#Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.
#Lets download the dependencies & build the software.
cd /app
go mod init dispatch
go get
go build

#We need to setup a new service in systemd so systemctl can manage this service

#INFO
#We already discussed in linux basics that advantages of systemctl managing services, Hence we are taking that approach. Which is also a standard way in the OS.
#Setup SystemD Payment Service
#/etc/systemd/system/dispatch.service
#[Unit]
Description = Dispatch Service
# shellcheck disable=SC1072
#[Service]
User=roboshop
Environment=AMQP_HOST=RABBITMQ-IP
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

#[Install]
WantedBy=multi-user.target

#INFO
#Hint! You can create file by using vim /etc/systemd/system/dispatch.service

#Load the service.

systemctl daemon-reload

#INFO
#This above command is because we added a new service, We are telling systemd to reload so it will detect new service.
#Start the service.

systemctl enable dispatch
systemctl start dispatch
