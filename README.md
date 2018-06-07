# docker-timeoff-management

Docker implementation of the timeoff-management project

# Using Dockerfile

By default timeoff-management use sqlite and no smtp server configured. 



To change default configurations use **environment variables**. 

| Var Name | Possible values|
| -------- | ------ |
| **NODE_ENV** | developement(default), test, production |
| **SENDER_MAIL** | email address |
| **SMTP_HOST** | host |
| **SMTP_PORT** | port |
| **SMTP_USER** | username/address |
| **SMTP_PASSWORD** | password |
| **APP_URL** | http://app.timeoff.management (default) |
| **PROMOTION_URL** | http://timeoff.management |
| **ALLOW_ACCOUNTS_CREATION** | true , false |

### Build and run docker image 

_Build_:
> $ docker build -t timeoff . 

_Run_:
> $ docker run -e NODE_ENV=production -e MYSQL_USER=timeoff timeoff
