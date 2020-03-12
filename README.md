# docker-timeoff-management

Docker implementation of the timeoff-management project

## Using Dockerfile

By default timeoff-management use sqlite and no smtp server configured.

To change default configurations use **environment variables**.

| Var Name | Possible values|
| -------- | ------ |
| **NODE_ENV** | development(default), test, production |
| **SENDER_MAIL** | email address |
| **SMTP_HOST** | host |
| **SMTP_PORT** | port |
| **SMTP_USER** | username/address |
| **SMTP_PASSWORD** | password |
| **APP_URL** | <http://app.timeoff.management> (default) |
| **PROMOTION_URL** | <http://timeoff.management> |
| **ALLOW_ACCOUNTS_CREATION** | true , false |

## Tags

Tags are written using the following pattern: `timeoff-management:<year>.<month>.<revision>`

* timeoff-management:18.09.0
* timeoff-management:18.07.0
* timeoff-management:18.03.1
* timeoff-management:18.03.0

More info on docker hub: <https://hub.docker.com/r/nosinovacao/timeoff-management/>

### Build and run docker image

_Build_:
> $ docker build -t timeoff .

_Run_:
> $ docker run -e NODE_ENV=production -e MYSQL_USER=timeoff timeoff
