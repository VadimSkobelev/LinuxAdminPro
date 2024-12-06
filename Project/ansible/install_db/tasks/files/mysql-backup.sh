#!/bin/bash

xtrabackup --host=localhost --port=3306 --user=root --password='str0ngRootP@ssw0rd!$$' --backup --target-dir=/tmp/mysql-db_$(date +"%Y-%m-%d_%H-%M")
cd /tmp/ && tar -czf /mysql-backup/mysql-db_$(date +"%Y-%m-%d_%H-%M").tar.gz mysql-db*
rm -rf /tmp/mysql-db*
find /mysql-backup/* -type f -mmin +30 -delete