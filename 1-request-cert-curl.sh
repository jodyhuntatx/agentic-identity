#!/bin/bash

source ./demo-vars.sh

if [[ $# < 1 || $# > 2 ]]; then
  echo "Usage:"
  echo "   $0 <service-name>"
  exit -1
fi
export SVC_NAME=$1

if [[ $# == 2 ]]; then
  export VALIDITY_PERIOD=$2
else
  export VALIDITY_PERIOD=P7D
fi

set -x
export JWT=$(curl -s	-X POST					\
	-H "Content-Type: application/x-www-form-urlencoded"	\
	-d "workload=$WORKLOAD_ID"				\
	http://localhost:$JWT_EXT_PORT/token | jq -r .access_token)
export CN=$SVC_NAME.$TRUST_DOMAIN_ID
export ALT_DNS=$SVC_NAME.$TRUST_DOMAIN_ID
export KEY_TYPE=RSA_2048

curl -sk 'https://localhost:8282/v1/certificaterequest' \
	-H 'Content-Type: application/json' 				\
 	-H "Authorization: Bearer $JWT" 					\
  -d "{													\
  	  \"subject\": {									\
	     \"commonName\":\"$CN\"							\
	  },												\
	  \"altNames\": {									\
	  	\"dnsNames\": [									\
			\"$ALT_DNS\"								\
		]												\
	  },												\
	  \"keyType\":\"$KEY_TYPE\",						\
	  \"validityPeriod\": \"$VALIDITY_PERIOD\",			\
	  \"policyName\":\"$POLICY_NAME\"					\
     }"													\
  > response.json

cat response.json | jq -r .certificateChain > $CN.crt
cat response.json | jq -r .privateKey > $CN.key

echo "Certificate:"
openssl x509 -in $CN.crt -text -noout
