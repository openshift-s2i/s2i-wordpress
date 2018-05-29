# Bonnier News Wordpress Docker images

This repository contains the source for creating a
[source-to-image](https://github.com/openshift/source-to-image) builder image,
which can be used to create reproducible Docker images with [Wordpress](https://wordpress.org)

For more information about using these images with OpenShift, please see
the official
[OpenShift
Documentation](https://docs.openshift.org/latest/using_images/s2i_images/php.html).

This repo is built on https://github.com/openshift-s2i/s2i-wordpress

The image extends the php s2i images with nodejs 8. Thus making i possible to run things like `gulp` during the `assemble` phase. It also includes `apcu` extensions for objectlevel caches in php.

It builds 2 variants / wordpress version, one using php 5.6 and one using php 7.0.

*To switch versions, change your build config and point to the imagestream you want to use/test.*

## Versions

Wordpress versions currently supported are:

* Wordpress (php 5.6) 4.5 (4.5.8, latest) 
* Wordpress (php 5.6) 4.6 (4.6.5, latest)
* Wordpress (php 5.6) 4.7 (4.7.4, latest)
* Wordpress (php 5.6 + php 7.0) 4.7.9
* Wordpress (php 5.6 + php 7.0) 4.9.2


## Usage

These images are intended to be used with the provided templates in the `openshift` folder.

Add the image streams and the template to your Openshift cluster.

## wp-cli
The images includes wp-cli for enabling cli access to the wordpress installation. Just run `wp` in the working directory of the image.

## Building the s2i container

Just run `make build` to build the container. Push it by running `make push`.

Update and replace the imagestreams and templates:

`oc replace -f openshift/* -n openshift`

## Overriding s2i behaviour

Adding a `.s2i/bin` folder in the root of your repo allows overriding the default `assemble` and `run` scripts used by the builder.

Checkout mittkök for an example.

## Migrating to Openshift
Use the template to setup the environment. Then rsync uploads and restore the database:
* Start by rsyncing the old content: `mkdir -p tmp && rsync -L -a --progress -e "ssh -p <port>" user@existingserver.com:/var/www/webroot/ROOT/wp-content/* tmp/`
* rsync content to the pod's persistent storage: `oc rsync wp-content/uploads $(oc get po -l name=bloggar -o name| cut -d "/" -f2):/opt/app-root/wp-content/ -c wordpress --progress=true --strategy=rsync-daemon --no-perms=true`
* Dump the current database: `ssh user@existingserver.com "cd webroot/ROOT && nice -n 19 ~/bin/wp --url=old.com --quiet db export -" > dump.sql` 
* Start a portforward to the myslq pod: `oc port-forward $(oc get po -l name=mysql -o name| cut -d "/" -f2) 3306:3306` 
* Restore the database:  `cat ~/tmp/dump.sql |mysql -h 127.0.0.1 -u <dbuser> -p<dbpassword> wordpress` 

* Or all-in-one: `ssh -p 22 user@old.com "cd webroot/ROOT && nice -n 19 ~/bin/wp --url=old.com --quiet db export -" | oc rsh $(oc get po -o name -l name=mysql) /opt/rh/rh-mysql57/root/usr/bin/mysql -u root wordpress` 

* Fix any changes to the url(s): `wp search-replace --url=http://old.com 'http://old.com' 'https://new.com' --recurse-objects --network --skip-columns=guid --skip-tables=wp_users`



## Testing

* Install `s2i` from [s2i releases](https://github.com/openshift/source-to-image/releases).

Then start a mysql container:
`docker run -d -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 3306:3306 --name mysql mysql`

Restore the database:
`cat wordpress.sql|mysql -h 127.0.0.1 -u wordpress -pwordpress wordpress`

Download|Update wp-content from the current installation.


Then build and run s2i:

```
export WP_CONTENT=../my-wp/wp-content
export WP_S2I_VERSION="-php70-49"
export WP_SRC_DIR=../my-wp/

s2i build ${WP_SRC_DIR}  bonniernews/s2i-wordpress${WP_S2I_VERSION}:4.9.4  --pull-policy=never --copy my-wp
docker run -v ${WP_CONTENT}:/opt/app-root/wp-content -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DEBUG=true --link mysql:mysql -it -p 8080:8080 my-wp
```


Update site urls and admin password using wp-cli:

```
wp user update 1 --user_pass=demo
wp option update home 'http://localhost:8080'
wp option update siteurl 'http://localhost:8080'
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
