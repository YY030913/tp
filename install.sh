#!/usr/bin/env bash

ROOTPATH=/var/www/caoliao
PM2FILE=pm2.json
if [ "$1" == "development" ]; then
  ROOTPATH=/var/www/caoliao.dev
  PM2FILE=pm2.dev.json
fi

cd $ROOTPATH
curl -fSL "https://s3.amazonaws.com/caoliaobuild/caoliao-develop.tgz" -o caoliao.tgz
tar zxf caoliao.tgz  &&  rm caoliao.tgz
cd $ROOTPATH/bundle/programs/server
npm install
pm2 startOrRestart $ROOTPATH/current/$PM2FILE
