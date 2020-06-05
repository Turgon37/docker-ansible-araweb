#
# First stage : download dependancies
#
FROM node:lts as deps

ARG ARAWEB_VERSION

WORKDIR /tmp
RUN git clone https://github.com/ansible-community/ara-web -b $ARAWEB_VERSION --depth 1

WORKDIR /tmp/ara-web
RUN npm install --production --verbose
RUN npm run-script build

#
# Second stage : install ara
#
FROM nginx:alpine as base

LABEL maintainer='Pierre GINDRAUD <pgindraud@gmail.com>'

ENV ARA_API_URL http://localhost:8000

COPY --from=deps /tmp/ara-web/build /usr/share/nginx/html

COPY vhost.nginx.conf /etc/nginx/conf.d/default.conf

RUN apk add --no-cache \
      curl \
      jq

HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
    CMD curl --silent --fail http://localhost:80 || exit 1

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
