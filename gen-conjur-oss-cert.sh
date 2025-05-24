#!/bin/bash

source ./demo-vars.sh

if [[ $# == 2 ]]; then
  export VALIDITY_PERIOD=$2
else
  export VALIDITY_PERIOD=P1Y
fi

set -x
export JWT=$(curl -s	-X POST					\
	-H "Content-Type: application/x-www-form-urlencoded"	\
	-d "workload=$WORKLOAD_ID"				\
	http://localhost:$JWT_EXT_PORT/token | jq -r .access_token)
export CN=proxy
export KEY_TYPE=RSA_2048

curl -sk "https://localhost:$REST_EXT_PORT/v1/certificaterequest"	\
	-H 'Content-Type: application/json' 				\
 	-H "Authorization: Bearer $JWT" 				\
  -d "{									\
	  	\"altNames\": {						\
	  		\"dnsNames\": [						\
				\"localhost\",					\
				\"proxy\"					\
			],							\
			\"ipAddresses\": [ \"127.0.0.1\" ]			\
	  	},								\
	  \"keyType\":\"$KEY_TYPE\",					\
	  \"validityPeriod\": \"$VALIDITY_PERIOD\",			\
	  \"policyName\":\"$POLICY_NAME\"				\
     }"									\
  > response.json

cat response.json | jq -r .certificateChain > $CN.crt
cat response.json | jq -r .privateKey > $CN.key

echo "Certificate:"
openssl x509 -in $CN.crt -text -noout
exit

  	  	\"subject\": {						\
	     	\"commonName\":\"$CN\"					\
	  	},								\
