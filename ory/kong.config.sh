#!/bin/bash

# Creates an secure-api service
# and proxies network traffic to oathkeeper
curl -i -X POST \
    --url http://localhost:8001/services/ \
    --data 'name=secure-api' \
    --data 'url=http://oathkeeper:4455'

curl -i -X POST \
    --url http://localhost:8001/services/secure-api/routes \
    --data 'paths[]=/' \
    --data 'name=hello'

curl -i -X GET \
    --url http://localhost:8000/