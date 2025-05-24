#!/bin/bash

source ./demo-vars.sh

pushd docker-compose
  docker compose --profile firefly down
popd
