# LLM api keys
export OPENAI_API_KEY=$(keyring get cybrid openaiapi)
# Tool api keys
export TAVILY_API_KEY=$(keyring get cybrid tavilyapi)

# Universal Conjur variables
#export CONJUR_APPLIANCE_URL="https://cybr-secrets.secretsmgr.cyberark.cloud/api"
export CONJUR_APPLIANCE_URL="https://host.docker.internal:8443"
export CONJUR_ACCOUNT="conjur"
# Authn-specific Conjur variables
export CONJUR_AUTHENTICATOR_ID="authn-jwt/agentic"
# empty authn ID or authn-apikey selects api key authentication
#export CONJUR_AUTHENTICATOR_ID=""
export CONJUR_AUTHN_LOGIN="host/data/ansible-xlr8r"
export CONJUR_AUTHN_API_KEY=$(keyring get cybrid anxlr8rapi)
