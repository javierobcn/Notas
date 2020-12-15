## Instalar SQLite

* SQLite is a software library that implements a self-contained, serverless, zero-configuration, transactional SQL (SQL92) database engine.

* SQLite does not require a separate server process or system to operate (serverless) and hasn't external dependencies. In fact, SQLite engine is not a standalone process like other databases, so you can link it statically or dynamically as per your requirement with your application.

* SQLite accesses its storage files directly (database is stored in a single cross-platform disk file).

------------------------

To install, you can download source code from official site (https://www.sqlite.org/download.html) and write the following commands:

    tar xvfz sqlite-snapshot-2019xxxxxx.tar.gz
    cd sqlite-snapshot-2019xxxxxxxx
    ./configure --prefix = /usr/local
    make
    sudo make install



##Compactar base de datos SQLite

A medida que se van borrando y escribiendo nuevos registros, la base de datos SQLite puede ir fragmentándose y haciendose mas grande, lo cual ocasiona una pérdida de rendimiento.

Con el comando vacuum puedes desfragmentar y reclamar el espacio no usado, todo de una tacada y sin necesidad de parar la base de datos.

Lanza el comando vacuum y de forma automática se creará una nueva base de datos y se copiarán las tablas y los datos en sectores adyacentes. Es la forma más rápida de «limpiar» una base de datos SQLite.

Se puede hacer desde el terminal con los comandos

    sqlite3 nombrebd
    
vacuum;

##Resetear campo autonumerico en SQLite

Como resetear a cero un campo autonumérico de identidad en SQLite.

En SQLite hay una tabla llamada SQLITE_SEQUENCE, en la cual se realiza un seguimiento del valor mas alto que tiene cada tabla

Es una tabla mas por lo que en ella se pueden ejecutar inserts, updates y deletes

Para realizar algo similar al TRUNCATE TABLE que ejecutariamos en SQL Server hariamos:

    DELETE FROM MyTableName;DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'MyTableName';
    
## Errores y soluciones

###SQLite operational error, database is locked

Es un error que puede aparecer al utilizar el scheduler, se soluciona ejecutando una sola vez en la base de datos la instruccion:

    pragma journal_mode = wal