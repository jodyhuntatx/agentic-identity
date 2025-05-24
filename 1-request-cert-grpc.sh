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

grpcurl -insecure \
  -rpc-header "authorization: Bearer $JWT"		\
  -d "{ \"request\": {					\
   	  \"subject\": {				\
	     \"common_name\":\"$CN\"			\
	  },						\
	  \"alt_names\": {				\
	  	\"dns_names\": [			\
			\"$ALT_DNS\"			\
		]					\
	  },						\
	  \"key_type\":\"$KEY_TYPE\",			\
	  \"validity_period\": \"$VALIDITY_PERIOD\",	\
	  \"policy_name\":\"$POLICY_NAME\"		\
       }						\
     }" 						\
  localhost:$GRPC_EXT_PORT certificates.service.v1alpha1.CertificateRequestService.Create	\
  > response.json

cat response.json | jq -r .response.certificateChain | base64 -d > $CN.crt
cat response.json | jq -r .response.privateKey | base64 -d > $CN.key

echo "Certificate:"
openssl x509 -in $CN.crt -text -noout
