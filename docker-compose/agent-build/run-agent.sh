#!/bin/bash
source ./set_env_vars.sh
cat agentSecretMap.template.json		\
 | sed -e "s#{{SAFE_NAME}}#$SAFE_NAME#g"	\
 | sed -e "s#{{ACCOUNT_NAME}}#$ACCOUNT_NAME#g"	\
 > agentSecretMap.json
poetry run python lg-mysql.py
