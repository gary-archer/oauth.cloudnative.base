#!/bin/bash

#############################
# Tear down the Docker system
#############################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Clear any existing data, and use a utility container to ensure deletion of the data folder
#
docker compose --project-name wordpress down 2>/dev/null
docker run --rm -v $(pwd):/data -w /data alpine rm -rf data
rm -rf data 2>/dev/null
