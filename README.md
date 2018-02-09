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
* Wordpress 4.7.9
* Wordpress 4.9.2


## Usage

These images are intended to be used with the provided templates in the `openshift` folder.

Add the image streams and the template to your Openshift cluster.

## Overriding s2i behaviour

Adding a `.s2i/bin` folder in the root of your repo allows overriding the default `assemble` and `run`scripts used by the builder.

## Testing

* Install `s2i`.

Then start a mysql container:

`docker run -d -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 3306:3306 --name mysql mysql`


Then build and run s2i:

```
export WP_SRC_DIR=/users/kalle.anka/src/my-wp
export WP_S2I_VERSION="-php70-49"
export WP_CONTENT=/users/kalle.anka/src/my-wp-contentx

make build && s2i build ${WP_SRC_DIR}  bonniernews/s2i-wordpress${WP_S2I_VERSION}:4.9.4  --pull-policy=never --copy my-wp
docker run -v ${WP_CONTENT}:/opt/app-root/wp-content -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DEBUG=true --link mysql:mysql -it -p 8080:8080 my-wp
```


Point your browser http://localhost:8080




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
