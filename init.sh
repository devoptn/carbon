#! /bin/ash

printenv | tee /var/www/html/.env

if [ "$CRON" = true ] ; then
    mv /setup/supervisor.cron.conf /etc/supervisor.d/cron.conf
    if [ ! -d /etc/crontabs ]; then
        mkdir /etc/crontabs
    fi
    cron="*       *       *       *       *       /usr/bin/php /var/www/html/artisan schedule:run >> /dev/stdout"
    echo "$cron" > "/etc/crontabs/root"
elif [ "$WORKER" = true ] ; then
    mv /setup/supervisor.worker.conf /etc/supervisor.d/worker.conf
elif [ "$HORIZON" = true ] ; then
    mv /setup/supervisor.horizon.conf /etc/supervisor.d/horizon.conf
else
    mv /setup/supervisor.nginx.conf /etc/supervisor.d/nginx.conf
fi

exec /usr/bin/supervisord -n -c /etc/supervisor.d/supervisord.ini
