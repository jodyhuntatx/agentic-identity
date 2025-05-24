#!/bin/bash
rm response.json *.crt *.key
rm -rf docker-compose/trust docker-compose/config/trust
rm docker-compose/config/svc-acct.key
rm -rf conjur-oss-cloud
