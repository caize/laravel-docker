#!/bin/bash

php artisan key:generate
php artisan migrate
php artisan db:seed

supervisord -c /etc/supervisor/supervisord.conf
