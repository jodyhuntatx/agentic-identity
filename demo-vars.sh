# API keys, passwords, etc. to keep out of repo
source ~/AIML/ENVs/AI-env.sh

export DOCKER="docker"
export DOCKER_CLI_HINTS=false

# set CONJUR to 'cloud' or 'oss'
export CONJUR=oss

# set FIREFLY to 'ent' or 'dev'
export FIREFLY=dev

# Linux or Darwin
export OS_TYPE=$(uname -s)
if [[ "$OS_TYPE" == "Linux" ]]; then
  export EXT_IP_ADDR=35.182.177.44
else
  export EXT_IP_ADDR=$(ifconfig en0 | grep 'inet ' | awk '{print $2}')
fi

case $CONJUR in
  oss)
    # Environment variables specific to Conjur OSS/coss-cli.sh
    export CONJUR_CLI=coss-cli.sh
    export HTTP_VERIFY=False
    export CONJUR_APPLIANCE_URL=https://localhost:8443
    export CONJUR_ACCOUNT=conjur
    export CONJUR_ADMIN_USER=admin
    export CONJUR_ADMIN_PASSWORD=CyberArk11@@
    export SAFE_NAME=TestSafe
    export ACCOUNT_NAME=MySQL-DB
    ;;
  cloud)
    # Environment variables specific to Conjur Cloud/ccloud-cli.sh
    export CONJUR_CLI=ccloud-cli.sh
    export CYBERARK_EMAIL_DOMAIN=cyberark.cloud.3357
    export CYBERARK_IDENTITY_PORTAL_ID=aao4987
    export CYBERARK_TENANT_SUBDOMAIN=cybr-secrets
    export CYBERARK_IDENTITY_URL=https://${CYBERARK_TENANT_SUBDOMAIN}.cyberark.cloud/api/idadmin
    export CYBERARK_CCLOUD_API=https://${CYBERARK_TENANT_SUBDOMAIN}.secretsmgr.cyberark.cloud/api
    export CONJUR_APPLIANCE_URL=$CYBERARK_CCLOUD_API

    # Admin - Oauth2 confidential client service user
    export CYBERARK_ADMIN_USER=newjodybot@${CYBERARK_EMAIL_DOMAIN}
    export CYBERARK_ADMIN_PWD=$(keyring get cybrid newjodybotpwd)
    export SAFE_NAME=JodyDemo
    export ACCOUNT_NAME=K8sSecrets-MySQL
    ;;
  *)
    echo "CONJUR must be either 'cloud' or 'oss'."
    ;;
esac

## FireFly vars ##
# Private service account key for Firefly Enterprise mode
export LOCAL_PKEY="/tmp/ffsa.key"
export CLIENT_ID="d8e0c523-31b1-11f0-aaea-e680e855fc59"
# Firefly config ports
export JWT_INT_PORT=8000
export REST_INT_PORT=8002
export GRPC_INT_PORT=8004
# External container ports mapped to internal ports
export JWT_EXT_PORT=8001
export REST_EXT_PORT=8003
export GRPC_EXT_PORT=8005
# JWKS endpoint
export JWKS_INT_URI=http://jwt-this.org:${JWT_INT_PORT}/.well-known/jwks.json
export JWKS_EXT_URI=http://localhost:${JWT_EXT_PORT}/.well-known/jwks.json
export TRUST_DOMAIN_ID=cyberark.org
export INSTANCE_NAME="Firefly Playground"
export CONFIG_NAME="Firefly Playground"
export POLICY_NAME="Firefly Playground"

# Conjur JWT authn values
export AUTHN_JWT_ID=agentic
export JWT_POLICY_TEMPLATE=authn-jwt.yml.template
export IDENTITY_PATH=data/$AUTHN_JWT_ID         # Conjur policy path to host identity definition
export TOKEN_APP_PROPERTY=workload              # claim containing name of host identity
export WORKLOAD_ID=ai-agent
export JWT_ISSUER=http://localhost:${JWT_EXT_PORT}
export JWT_AUDIENCE=conjur
# Workload authn/authz policy templates
export JWT_APP_POLICY_TEMPLATE=app-authn-jwt.yml.template
export JWT_AUTHN_GRANT_POLICY_TEMPLATE=app-authn-grant.yml.template
export JWT_SECRETS_GRANT_POLICY_TEMPLATE=app-secrets-grant.yml.template

# Variable to retrieve for testing
export VAR_ID=data/vault/$SAFE_NAME/$ACCOUNT_NAME/password

# MySQL vars
export MYSQL_IMAGE=mysql:8.2.0
export MYSQL_CONTAINER=mysql-xlr8r
export MYSQL_ROOT_PASSWORD=In1t1alR00tPa55w0rd
# MySQL account properties - retrieved from Conjur
export MYSQL_PLATFORM_NAME=MySQL
export MYSQL_USERNAME=test_user1
export MYSQL_PASSWORD=UHGMLk1
export MYSQL_SERVER_ADDRESS=mysql
export MYSQL_SERVER_PORT=3306
export MYSQL_DBNAME=petclinic
