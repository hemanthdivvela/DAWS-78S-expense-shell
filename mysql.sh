#!/bin/bash

USERID=$(id-u)
TIMESTAMP=$(data +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB PASSWORD:"
read -s mysql_root_password


VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R FAILURE $N"
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0]
then
    echo "Please run the script with root access.."
    exit1
else
    echo "your super user."

fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySql Server"

mysql_secure_installation --set-root-pas ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root Password"