FROM centos/php-56-centos7:latest
ARG WORDPRESS_VERSION
ARG WORDPRESS_SHA1
ENV WORDPRESS_VERSION ${WORDPRESS_VERSION:-4.5}
ENV WORDPRESS_SHA1 ${WORDPRESS_SHA1:-439f09e7a948f02f00e952211a22b8bb0502e2e2}

VOLUME /opt/app-root/wp-content

# Install wordpress and backup the base image S2I scripts
USER root
RUN cd /tmp && curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && mkdir -p /opt/app-root/wordpress \
    && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
    && tar -xzf wordpress.tar.gz --strip-components=1 -C /opt/app-root/wordpress \
    && rm wordpress.tar.gz \
    && mv /opt/app-root/wordpress/wp-content /opt/app-root/wordpress/wp-content-install \
    && mv $STI_SCRIPTS_PATH/run $STI_SCRIPTS_PATH/run-base \
    && mv $STI_SCRIPTS_PATH/assemble $STI_SCRIPTS_PATH/assemble-base \
    && fix-permissions /opt/app-root/wordpress \
    && fix-permissions /opt/app-root/wp-content && chmod -R 0777 /opt/app-root/wp-content


# Copied from the official Wordpress Docker image
RUN { \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=4000'; \
      echo 'opcache.revalidate_freq=60'; \
      echo 'opcache.fast_shutdown=1'; \
      echo 'opcache.enable_cli=1'; \
      } > /etc/opt/rh/rh-php56/php.d/11-opcache-wordpress.ini

# Install config templates
COPY contrib/* /opt/app-root/wordpress/

# Install wordpress S2I scripts
COPY s2i/bin/* $STI_SCRIPTS_PATH/
USER 1001
