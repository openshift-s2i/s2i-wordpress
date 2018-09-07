#!/bin/bash
set -e -o pipefail
docker pull centos/php-70-centos7:latest
## php 5.6
#for version in ${VERSIONS}; do
#    _version=$(echo ${version} | cut -d ":" -f1)
#    _short_version=$(echo ${_version//./} | cut -c 1,2 )
#    _sha1=$(echo ${version} | cut -d ":" -f2)
#    echo "=== Building Wordpress s2i php 5.6 v${_version}"
#    docker build -f Dockerfile.5.6 --build-arg WORDPRESS_VERSION=${_version} --build-arg WORDPRESS_SHA1=${_sha1} \
#    -t ${NAMESPACE}/${BASE_IMAGE_NAME}${_short_version}:${_version} \
#    --label io.bonniernews.wordpress.version="${_version}" \
#    --label io.bonniernews.wordpress.build.date="$(date +%c)" \
#    --label io.bonniernews.wordpress.build.user="${USER}" .
#done

## php 7.0
for version in ${VERSIONS}; do
    _version=$(echo ${version} | cut -d ":" -f1)
    _short_version=$(echo ${_version//./} | cut -c 1,2 )
    _sha1=$(echo ${version} | cut -d ":" -f2)
    echo "=== Building Wordpress s2i php 7.0 v${_version}"
    docker build --rm -f Dockerfile.7.0 --build-arg WORDPRESS_VERSION=${_version} --build-arg WORDPRESS_SHA1=${_sha1} \
    -t ${NAMESPACE}/${BASE_IMAGE_NAME}-php70-${_short_version}:${_version} \
    --label io.bonniernews.wordpress.version="${_version}" \
    --label io.bonniernews.wordpress.build.date="$(date +%c)" \
    --label io.bonniernews.wordpress.build.user="${USER}" .
done

## apache_exporter
docker build -f Dockerfile.apache_exporter \
    -t ${NAMESPACE}/apache_exporter:latest \
    --label io.bonniernews.apache_exporter.build.date="$(date +%c)" \
    --label io.bonniernews.apache_exporter.build.user="${USER}" \
    --label io.bonniernews.apache_exporter.repo="s2i-wordpress"  .