#!/bin/bash
set -e -o pipefail
for version in ${VERSIONS}; do
    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:${_version}
    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:latest
done