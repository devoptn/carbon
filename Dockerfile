FROM alpine:latest

ENV CRON false
ENV HORIZON false
ENV WORKER false

ENV VERSION 1.1

RUN apk add --no-cache \
    $( apk search -qe --no-cache 'php7*' | cat )    \
    autoconf                                        \
    automake                                        \
    composer                                        \
    curl                                            \
    g++                                             \
    gifsicle                                        \
    git                                             \
    libpng-dev                                      \
    libtool                                         \
    make                                            \
    nano                                            \
    nasm                                            \
    nginx                                           \
    nodejs                                          \
    nodejs-npm                                      \
    openssh-client                                  \
    optipng                                         \
    supervisor                                      \
    wget

ADD ./docker /setup

RUN mkdir -p /etc/supervisor.d && \
    mv /setup/supervisord.ini /etc/supervisor.d/supervisord.ini && \
    mv /setup/supervisor.php.conf /etc/supervisor.d/php.conf

RUN mkdir -p /run/php && \
    rm -rf /etc/php7/php-fpm.d/www.conf && \
    cp /setup/www.conf /etc/php7/php-fpm.d/www.conf

RUN mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/log/php7 && \
    rm -rf /etc/nginx/nginx.conf && \
    mv /setup/nginx.conf /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    mv /setup/nginx.laravel.conf /etc/nginx/conf.d/laravel.conf

RUN chmod a+rwx /setup/init.sh

EXPOSE 80

CMD [ "/setup/init.sh" ]
