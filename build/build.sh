#!/bin/bash
set -e -o pipefail
for version in ${VERSIONS}; do
    _version=$(echo ${version} | cut -d ":" -f1)
    _short_version=$(echo ${_version//./} | cut -c 1,2 )
    _sha1=$(echo ${version} | cut -d ":" -f2)
    echo "=== Building Wordpress s2i v${_version}"
    docker build --build-arg WORDPRESS_VERSION=${_version} --build-arg WORDPRESS_SHA1=${_sha1} \
    -t ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:latest \
    -t ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:${_version} \
    --label io.bonniernews.wordpress.version="${_version}" \
    --label io.bonniernews.wordpress.build.date="$(date +%c)" \
    --label io.bonniernews.wordpress.build.user="${USER}" .
    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:${_version}
    docker push ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:latest
done

