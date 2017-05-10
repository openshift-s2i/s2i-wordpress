# Bonnier News Wordpress Docker images

This repository contains the source for creating a
https://github.com/openshift/source-to-image[source-to-image] builder image,
which can be used to create reproducible Docker images with https://wordpress.org[Wordpress]

For more information about using these images with OpenShift, please see
the official
https://docs.openshift.org/latest/using_images/s2i_images/php.html[OpenShift
Documentation].

This repo is built on https://github.com/openshift-s2i/s2i-wordpress

## Versions

Wordpress versions currently supported are:

* Wordpress 4.5 (4.5.8)
* Wordpress 4.6 (4.6.5)
* Wordpress 4.7 (4.7.4)


## Usage

These images are intended to be used with the provided templates in the `openshift` folder.

Add the image streams and the template to your Openshift cluster.

## Testing

* Install `s2i`.

Then start a mysql container:

`docker run -d -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 3306:3306 --name mysql mysql`


Then build and run s2i:

`make build && s2i build ../bbm-resumeblogg  bonniernews/s2i-wordpress47:latest  --pull-policy=never --copy resume-blog; docker run -v /tmp/wp-content:/opt/app-root/wp-content -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DEBUG=true --link mysql:mysql -it -p 8080:8080 resume-blog`

Point your browser http://localhost:8080



oc delete all --all && oc delete persistentvolumeclaim --all && oc delete -n openshift imagestream wordpress && oc delete template wordpress-mysql-persistent && oc delete secret wordpress-mysql && oc create -n openshift -f openshift/bonniernews-wordpress-image-streams.yaml && oc create -f openshift/wordpress-template.yaml && oc process wordpress-mysql-persistent| oc create -f -



## Copyright and License

Copyright 2017 by Bonnier News AB.

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this package except in compliance with the License (see the `LICENSE` file
included in this distribution). You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
