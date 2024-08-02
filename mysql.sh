#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


VALIDATA(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2... $R FAILURE $N"
        exit 1
    else
        echo -e "$2... $G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 #manually exit if error comes.
else
    echo "you are super user."
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATA $? "Installing mysql Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATA $? "enable mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATA $? "start mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATA $? "seeting up root password"