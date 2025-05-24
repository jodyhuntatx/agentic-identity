#!/bin/bash
set -eou pipefail

source ../demo-vars.sh

#################
main() {
  configure_authn_jwt
  set_authn_jwt_variables
  ./$CONJUR_CLI enable authn-jwt $AUTHN_JWT_ID
  ./$CONJUR_CLI status authn-jwt $AUTHN_JWT_ID
}

###################################
configure_authn_jwt() {
  echo "Initializing Conjur JWT authentication policy..."
  mkdir -p ./policy
  cat ./templates/$JWT_POLICY_TEMPLATE				\
  | sed -e "s#{{ AUTHN_JWT_ID }}#$AUTHN_JWT_ID#g"		\
  > ./policy/$JWT_POLICY_TEMPLATE
  ./$CONJUR_CLI append /conjur/authn-jwt ./policy/$JWT_POLICY_TEMPLATE
}

############################
set_authn_jwt_variables() {
  # Get signing keys from K8s cluster
  JWT_TEST=$(curl -s -o /dev/null -w "%{http_code}" $JWKS_EXT_URI)
  if [[ "$JWT_TEST" == "" ]]; then
    echo "Error retrieving JWT_KEYS from $JWKS_EXT_URI."
    exit -1
  fi
#  JWT_KEYS=$(kubectl get --raw /openid/v1/jwks)
  JWT_KEYS=$(curl -s $JWKS_EXT_URI)
  echo "Initializing Conjur JWT authentication variables..."
  ./$CONJUR_CLI set conjur/authn-jwt/$AUTHN_JWT_ID/audience $JWT_AUDIENCE
  ./$CONJUR_CLI set conjur/authn-jwt/$AUTHN_JWT_ID/issuer $JWT_ISSUER
  ./$CONJUR_CLI set conjur/authn-jwt/$AUTHN_JWT_ID/public-keys "{\"type\":\"jwks\", \"value\": $JWT_KEYS }"
   echo "Enabling authn-jwt/$AUTHN_JWT_ID endpoint..."
  ./$CONJUR_CLI set conjur/authn-jwt/$AUTHN_JWT_ID/token-app-property $TOKEN_APP_PROPERTY
   echo "Checking endpoint status..."
  ./$CONJUR_CLI set conjur/authn-jwt/$AUTHN_JWT_ID/identity-path $IDENTITY_PATH
}

main "$@"
