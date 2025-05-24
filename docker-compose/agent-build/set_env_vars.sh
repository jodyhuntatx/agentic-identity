# LLM api keys
export MISTRAL_API_KEY=$(keyring get cybrid mistralapi)
export OPENAI_API_KEY=$(keyring get cybrid openaiapi)
# Tool api keys
export TAVILY_API_KEY=$(keyring get cybrid tavilyapi)
# LangSmith env vars
export LANGCHAIN_TRACING_V2=false
export LANGCHAIN_ENDPOINT="https://api.smith.langchain.com"
export LANGCHAIN_API_KEY=$(keyring get cybrid langchainapi)
export LANGCHAIN_PROJECT="lg-agent-k8s"

# Universal Conjur variables
#export CONJUR_APPLIANCE_URL="https://cybr-secrets.secretsmgr.cyberark.cloud/api"
export CONJUR_APPLIANCE_URL="https://host.docker.internal:8443"
export CONJUR_AUTHENTICATOR_ID="authn-jwt/agentic"
# empty authn ID or authn-apikey selects api key authentication
#export CONJUR_AUTHENTICATOR_ID=""
export CONJUR_ACCOUNT="conjur"

# Authn-specific Conjur variables
export CONJUR_AUTHN_LOGIN="host/data/ansible-xlr8r"
export CONJUR_AUTHN_API_KEY=$(keyring get cybrid anxlr8rapi)
