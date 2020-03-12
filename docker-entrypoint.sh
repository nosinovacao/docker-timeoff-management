#!/bin/bash

if [[ -z $NODE_ENV ]]; then
	export NODE_ENV=production
fi

if [[ -z $SENDER_MAIL ]]; then
	SEND_MAILS=false
	SMTP_HOST="localhost"
	SMTP_PORT=25
	SMTP_USER=user
	SMTP_PASSWORD=password
else
	SEND_MAILS=true
	if [[ -z $SMTP_HOST ]]; then
		echo "You need to configure the SMTP_HOST variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_PORT ]]; then
		echo "You need to configure the SMTP_PORT variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_USER ]]; then
		echo "You need to configure the SMTP_USER variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_PASSWORD ]]; then
		echo "You need to configure the SMTP_PASSWORD variable to enable mails sending"
		SEND_MAILS=false
	fi
fi

if [[ -e /app/timeoff-management/config/crypto_secret ]]; then
	CRYPTO_SECRET=$(cat /app/timeoff-management/config/crypto_secret)
else
	echo -n $(tr -dc A-Za-z0-9_\#\(\)\!: < /dev/urandom | head -c 40 | xargs) > /app/timeoff-management/config/crypto_secret
	CRYPTO_SECRET=$(cat /app/timeoff-management/config/crypto_secret)
fi

if [[ -z $APP_URL ]]; then
	APP_URL=http://webapp.timeoff.management
fi

if [[ -z $PROMOTION_URL ]]; then
	PROMOTION_URL=http://timeoff.management
fi
if [[ -z $ALLOW_ACCOUNTS_CREATION ]]; then
	ALLOW_ACCOUNTS_CREATION=true
fi

if [[ -n $MYSQL_HOST && -n $MYSQL_USER && -n $MYSQL_PASSWORD ]]; then
	if [[ -z $MYSQL_DATABASE ]]; then
		MYSQL_DATABASE="timeoffmanagement"
	fi
	cat > /app/timeoff-management/config/db.json << EOF
  {
    "production": {
      "username": "$MYSQL_USER",
      "password": "$MYSQL_PASSWORD",
      "database": "$MYSQL_DATABASE",
      "host": "$MYSQL_HOST",
      "dialect": "mysql"
    }
  }
EOF
else
   cat > /app/timeoff-management/config/db.json << EOF
   {
     "production": {
        "dialect": "sqlite",
		"storage": "./db.production.sqlite"
     }
  }
EOF
fi

cat > /app/timeoff-management/config/app.json << EOF
{
  "allow_create_new_accounts" : $ALLOW_ACCOUNTS_CREATION,
  "send_emails"              : $SEND_MAILS,
  "application_sender_email" : "$SENDER_MAIL",
  "email_transporter" : {
    "host" : "$SMTP_HOST",
    "port" : $SMTP_PORT,
    "auth" : {
      "user" : "$SMTP_USER",
      "pass" : "$SMTP_PASSWORD"
    }
  },
  "crypto_secret" : "$CRYPTO_SECRET",
  "application_domain" : "$APP_URL",
  "promotion_website_domain" : "$PROMOTION_URL"
}
EOF
echo "========= PRINTING CONFIGURATION ========="
cat /app/timeoff-management/config/app.json

npm run-script db-update
npm start
