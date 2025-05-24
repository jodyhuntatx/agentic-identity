#!/bin/bash

source ./demo-vars.sh

AS_DAEMON="-d"

main() {
  ./_stop.sh

  # generate Firefly config
  case $FIREFLY in
    dev) gen_dev_config_yaml
	 ;;
    ent) gen_ent_config_yaml
	 ;;
    *) echo "Unknown value for FIREFLY: \'$FIREFLY\'"
  esac

  # bring up all containers
  ./write-docker-env.sh
  pushd docker-compose
    docker compose --profile firefly up $AS_DAEMON --build agent 
  popd

  # authn jwt must be configured after jwt-this is running
  if [[ "$CONJUR" == "oss" ]] ; then
    git clone git@github.com:jodyhuntatx/conjur-oss-cloud.git
    pushd conjur-oss-cloud
      ./start-conjur
      ./test_retrieval.sh
    popd
  fi
  config_conjur_authn_jwt

  # initialize MySQL DB
  init_mysql_db

  # configure agent
  set_keys_in_agent_container

  echo "localhost ports:"
  echo "  jwt-this:${JWT_EXT_PORT}"
  echo "  firefly-rest:${REST_EXT_PORT}"
  echo "  firefly-grpc:${GRPC_EXT_PORT}"
}

##### Generate development config #####
gen_dev_config_yaml() {
  cat <<EOF > docker-compose/config/config.yaml
bootstrap:
  selfSigned:
    csr:
      commonName: My Firefly
      privateKey:
        algorithm: ECDSA
        size: 256
      duration: 720h
    trustRootDirectory: /etc/firefly/trust
signer:
  inMemory: true
server:
  grpc:
    port: ${GRPC_INT_PORT}
    tls:
      dnsNames:
      - firefly
      ipAddress: 127.0.0.1
  rest:
    port: ${REST_INT_PORT}
    tls:
      dnsNames:
      - firefly
      ipAddress: 127.0.0.1
  authentication:
    jwt:
      jwks:
        urls:
        - $JWKS_INT_URI
  authorization:
    configuration: "$CONFIG_NAME"
policies:
- name: "$POLICY_NAME"
  keyUsages:
  - digitalSignature
  - keyEncipherment
  extendedKeyUsages:
  - SERVER_AUTH
  keyAlgorithm:
    allowedValues:
    - EC_P256
    - RSA_2048
    defaultValue: EC_P256
  validityPeriod: P7D
EOF
}

##### Generate enterprise (control plane) config #####
gen_ent_config_yaml() {
  cat <<EOF > docker-compose/config/config.yaml
bootstrap:
  vaas:
    auth:
      privateKeyFile: /etc/firefly/svc-acct.key
      clientID: ${CLIENT_ID}
    csr:
      instanceNaming: $INSTANCE_NAME
    url: https://api.venafi.cloud
server:
  grpc:
    port: ${GRPC_INT_PORT}
    tls:
      dnsNames:
      - firefly
      ipAddress: 127.0.0.1
  rest:
    port: ${REST_INT_PORT}
    tls:
      dnsNames:
      - firefly
      ipAddress: 127.0.0.1
EOF
}

##### Replicate API key values from env vars into agent container keyring #####
set_keys_in_agent_container() {
    keynames=("openaiapi" "mistralapi" "tavilyapi" "langchainapi" "newjodybotpwd" "ansxlr8rapi")
    for key in "${keynames[@]}" ; do
      echo "${!key}" \
        | $DOCKER exec -i agent keyring set cybrid $key
    done
}

##### Configure jwt-this JWKS keys in Conjur #####
config_conjur_authn_jwt() {
  pushd conjur-admin
    ./1-config-jwt-authn.sh
    ./2-load-app-policy.sh
  popd
}

##### Load database content and user(s) #####
init_mysql_db() {
  pushd mysql-admin
    ./init_mysql.sh
  popd
}

main "$@"
