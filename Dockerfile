# This is the base for our build step container
FROM node:13-alpine AS base

# Environment var to set pull request version
ENV PR_NUMBER 504

# Install dependencies
RUN apk add --no-cache git

# Create and change to workdir
WORKDIR /app
RUN git clone --branch 1.3.4 https://github.com/timeoff-management/application.git timeoff-management

WORKDIR /app/timeoff-management

# Checkout to the pull request
RUN git fetch origin pull/${PR_NUMBER}/head:pr_${PR_NUMBER} \
    && git checkout pr_${PR_NUMBER}

# Install dependencies
RUN npm install mysql && npm install --unsafe-perm --production

# 20190118-chnage-type-value-for-api-token.js isn't compatible with mariadb. A better solution is used to replace it
# Issue comment: https://github.com/timeoff-management/timeoff-management-application/issues/329#issuecomment-488327844
COPY scripts/20190118-chnage-type-value-for-api-token.js /app/timeoff-management/migrations/

# This is our runtime container
FROM alpine:3.13

# Install npm
RUN apk add --update nodejs npm

WORKDIR /app/timeoff-management

# Copy files from first stage
COPY --from=base /app/timeoff-management/ /app/timeoff-management

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]