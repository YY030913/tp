#!/bin/bash
set -x
set -euvo pipefail
IFS=$'\n\t'

CURL_URL="https://registry.hub.docker.com/u/caoliao/caoliao/trigger/$PUSHTOKEN/"

if [[ $TRAVIS_TAG ]]
 then
  CURL_DATA='{"source_type":"Tag","source_name":"'"$TRAVIS_TAG"'"}';
else
  CURL_DATA='{"source_type":"Branch","source_name":"develop"}';
fi

curl -H "Content-Type: application/json" --data "$CURL_DATA" -X POST "$CURL_URL"
