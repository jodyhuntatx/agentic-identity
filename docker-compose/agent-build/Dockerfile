FROM ubuntu:22.04

# install utilities
RUN apt update -y \
    && apt install -y \
    sudo \
    vim \
    ssh \
    curl \
    wget \
    unzip

RUN apt update -y \
    && apt install -y jq git

# install full python3 env
ENV PYTHONUNBUFFERED=1
RUN apt update -y             				\
    && apt install -y python3.11 python3-pip 		\
    && rm /usr/bin/python3				\
    && ln -sf /usr/bin/python3.11 /usr/bin/python3 	\
    && ln -sf python3 /usr/bin/python
RUN pip3 install --no-cache --upgrade pip 		\
	setuptools requests keyring keyrings.alt poetry

# Disable virtual environment creation
RUN poetry config virtualenvs.create false --local

# Copy executable resources to container
COPY *.py pyproject.toml run-agent.sh set_env_vars.sh uid_entrypoint.sh agentSecretMap.template.json /agent/
RUN mkdir -p /agent/agent_guard_core
COPY agent_guard_core /agent/agent_guard_core

# Cleanup
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# As root create a non-root user
USER root
ARG USERNAME=agent
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USER_HOME_DIR=/agent

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN chown $USERNAME:$USER_GID -R $USER_HOME_DIR

WORKDIR /agent

# setup entrypoint for default user
RUN chmod g=u /etc/passwd /agent/*
ENTRYPOINT [ "/agent/uid_entrypoint.sh" ]

USER $USERNAME
RUN poetry update
