#Respaldos semanales de bases de datos MySQL en Amazon S3 sistema de gestor de prestamos
SRCDIR='/tmp/s3backups'
DESTDIR='mysqldump' #nombre de la carpeta en local
BUCKET='name_bucket' #nombre del bucket en amazon s3
HRBKP=`date +"%d%m%Y-%Hh%Mm"` #fecha de respaldo
SERVER=`uname -n | cut -d\. -f1` #nombre del servidor
#### START CONFIGURATION ####
# database access details
HOST='localhost' #ip o nombre del servidor
PORT='3306' #puerto
USER='user' #usuario
PASS='pass' #contraseña
#### END CONFIGURATION ####
mkdir -p $SRCDIR #crea la carpeta de respaldo
cd $SRCDIR #entra a la carpeta de respaldo

#  backup all databases except mysql, information_schema, performance_schema
for DB in $(mysql -h$HOST -P$PORT -u$USER -p$PASS -BNe 'show databases' | grep -Ev 'mysql|information_schema|performance_schema')
do
	mysqldump -h$HOST -P$PORT -u$USER -p$PASS --quote-names --create-options --force $DB > $SERVER-$DB-$HRBKP.sql
	tar -czPf $SERVER-$DB-$HRBKP.tar.gz $SERVER-$DB-$HRBKP.sql
	/usr/local/bin/aws s3 cp $SRCDIR/$SERVER-$DB-$HRBKP.tar.gz s3://$BUCKET/$DESTDIR/
done

#  remueve el respaldo de la carpeta local
cd  #regresa a la carpeta anterior
rm -f $SRCDIR/* #borra los archivos de la carpeta de respaldo