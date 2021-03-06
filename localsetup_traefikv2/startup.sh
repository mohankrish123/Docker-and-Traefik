#!/bin/bash
set -e
docker exec gumbrand sh -c "composer self-update 1.6.0"
docker exec gumbrand sh -c "composer install -d /var/www/html/html"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento c:c"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento c:f"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento setup:upgrade"
docker exec gumbrand sh -c "redis-cli -h localhost -p 6379 FLUSHALL"
docker exec gumbrand sh -c "cd /var/www/html/html/ && patch -p1 < m2-hotfixes/Aheadworks_AdvancedSearch_Indexer_patch.patch"
docker exec gumbrand sh -c "cd /var/www/html/html/ && patch -p1 < m2-hotfixes/Aheadworks_Blog_patch.patch"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento setup:di:compile"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento setup:static-content:deploy -f"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento c:c"
docker exec gumbrand sh -c "php /var/www/html/html/bin/magento c:f"
docker exec gumbrand sh -c "chown -R nginx:nginx /var/www/html/html/"
docker exec gumbrand sh -c "chmod -R 775 /var/www/html/html/vendor/ /var/www/html/html/pub/ /var/www/html/html/generated/ /var/www/html/html/var/"
