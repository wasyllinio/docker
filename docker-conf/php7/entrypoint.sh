#!/bin/bash

# set -e

# if [ "x$DOCKER_XDEBUG" = "xyes" ]; then
    # echo "Enabling Xdebug..."
    echo "xdebug.remote_host=$DOCKER_HOST_IP" >/usr/local/etc/php/conf.d/xdebug-host.ini
# fi

# ls /var/www/html
# mkdir -m 777 /var/www/logs
# ls /var/www/html/ | xargs -I % mkdir -m 777 /var/www/logs/%

# exec apache2-foreground "$@"

# '#!/bin/bash\n([ -f bin/console ] && php bin/console --env=prod $*) || php app/console --env=prod $*'

# ls /var/www/html/ | xargs -I %([ -d /var/www/html/%] mkdir /var/www/logs/%)
# ls /var/www/html/ | xargs -I % bash -c  'if [ -d /var/www/html/% ] ; then mkdir -m 777 /var/www/logs/% && mkdir -m 777 /var/www/cache/% && mkdir -m 777 /var/www/vendors/% && cp -R /var/www/html/%/vendor/* /var/www/vendors/% ; fi'
cd /var/www/html
for d in *
do
    echo ${d}
    # -a !-d /var/www/cache/${d}
    if [ -d /var/www/html/${d} ]
    then
        if [ ! -d /var/www/cache/${d} ]; then
            mkdir -m 777 /var/www/cache/${d} && chown www-data:www-data /var/www/cache/${d} && chmod 777 -R /var/www/cache/${d}
        fi

        if [ ! -d /var/www/logs/${d} ]; then
            mkdir -m 777 /var/www/logs/${d} && chown www-data:www-data /var/www/logs/${d} && chmod 777 -R /var/www/logs/${d}
        fi
        
        if [ ! -d /var/www/html/${d}/vendor ]; then
            mkdir -m 777 /var/www/vendors/${d}
            cp -R /var/www/html/${d}/vendor /var/www/vendors/${d}/ && chown -R www-data:www-data /var/www/vendors/${d} && chmod 777 -R /var/www/vendors/${d}
        fi
        # ln -s /var/www/html/${d}/app/cache /var/www/cache/${d}
    else
        echo "${d} exists or is not a directory"
    fi
done

# cd /var/www/vendors
# for d in *
# do
#     echo ${d}
#     cp -R /var/www/html/${d}/vendor /var/www/vendors/${d}/
# done

# /usr/sbin/apache2ctl -D FOREGROUND
exec apache2-foreground "$@"
# ls /var/www/html/ | xargs -I % mkdir -m 777 /var/www/cache/%
