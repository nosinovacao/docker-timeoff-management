# This is the base for our build step container
FROM node:9-alpine AS base

#Environment var to set pull request version 
ENV PR_NUMBER 285

#Install dependencies 
RUN apk add --update --no-cache git

#Create and change to workdir
WORKDIR /app
RUN git clone https://github.com/timeoff-management/application.git timeoff-management

WORKDIR /app/timeoff-management

#Install dependencies    
RUN npm install mysql && npm install --production 

# This is our runtime container
FROM alpine:3.6

#Install npm 
RUN apk add --update nodejs-npm

WORKDIR /app/timeoff-management
#Copy files from first stage
COPY --from=base /app/timeoff-management/ /app/timeoff-management 

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["sh","/docker-entrypoint.sh"]
