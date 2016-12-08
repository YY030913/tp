FROM caoliao/base

ENV RC_VERSION latest

MAINTAINER buildmaster@caoliao

VOLUME /app/uploads

RUN set -x \
 && curl -SLf "https://caoliao/releases/${RC_VERSION}/download" -o caoliao.tgz \
 && curl -SLf "https://caoliao/releases/${RC_VERSION}/asc" -o caoliao.tgz.asc \
 && gpg --verify caoliao.tgz.asc \
 && tar -zxf caoliao.tgz -C /app \
 && rm caoliao.tgz caoliao.tgz.asc \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear

USER caoliao

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV MONGO_URL=mongodb://mongo:27017/caoliao \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
