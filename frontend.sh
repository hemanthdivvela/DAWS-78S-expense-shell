#/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Please enter DB password:"
read mysql_root_password

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

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATA $? "Removing exjecting content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATA $? "Dowland frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATA $? "extracting frontend code"
# check repo and path
cp /home/ec2-user/DAWS-78S-expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATA $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATA $? "Restarting nginx server"


