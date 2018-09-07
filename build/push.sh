#!/bin/bash
set -e -o pipefail
#for version in ${VERSIONS}; do
#    _version=$(echo ${version} | cut -d ":" -f1)
#    _short_version=$(echo ${_version//./} | cut -c 1,2 )
#    _sha1=$(echo ${version} | cut -d ":" -f2)
#    echo "=== Pushing Wordpress s2i v${_version}"
#    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:${_version}
#done

for version in ${VERSIONS}; do
    _version=$(echo ${version} | cut -d ":" -f1)
    _short_version=$(echo ${_version//./} | cut -c 1,2 )
    _sha1=$(echo ${version} | cut -d ":" -f2)
    echo "=== Pushing Wordpress s2i v${_version}"
    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}-php70-${_short_version}:${_version}
done

docker push ${NAMESPACE}/apache_exporter:latest