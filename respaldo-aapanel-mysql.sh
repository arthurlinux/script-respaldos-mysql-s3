#!/bin/bash
# 
#  Backup de bases de datos MySQL
BUCKET='name_bucket' #nombre del bucket en amazon s3
BACKUPS=$(find /www/backup/database/mysql/crontab_backup/sql_serviciosdti/ -name "sql_serviciosdti_$(date +%Y-%m-%d)*_mysql_data.sql.gz" -type f) #ruta de la carpeta local donde se guardaran los backups
/usr/local/bin/aws s3 cp $BACKUPS s3://$BUCKET