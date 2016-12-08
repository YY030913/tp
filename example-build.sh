#!/usr/bin/env bash

export METEOR_SETTINGS=$(cat settings.json)
meteor add caoliao:internal-hubot meteorhacks:kadira
meteor build --server https://demo.caoliao --directory /var/www/caoliao
cd /var/www/caoliao/bundle/programs/server
npm install
cd /var/www/caoliao/current
pm2 startOrRestart /var/www/caoliao/current/pm2.json
