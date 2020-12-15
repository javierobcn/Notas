
## PostgreSQL

PostgreSQL es un Sistema de gestión de bases de datos relacional orientado a objetos y libre.

The root user is an account on the system independent from Postgres. There is only one root user.

A superuser is an account in Postgres with access to everything. There may be many superusers.

System accounts and Postgres accounts are different things, although unless you specify a Postgres username when you connect to the database (through utilities like psql, createdb, dropdb, or otherwise), it will use the current system user's name in hopes that there is a corresponding Postgres account with the same name. The root user does not, by default, have a corresponding account in Postgres.

When you install Postgres on *nix, it creates both a superuser named postgres and a system user named postgres.

Therefore, when you need to do something with Postgres as the built-in superuser, you have two options:

You may sudo su - postgres to become the postgres system user and execute your command (createdb, psql, etc). Because the system user has the same name as the database superuser, your command will connect as the appropriate account.

You may specify the username to execute as with the -U switch, eg psql -U postgres ....

Depending on your Postgres server's authentication settings, you may be required to enter a password with either or both connection methods.



###comandos postgres

```bash

    # Hacer un backup de una base de datos
    pg_dump nombasedatos > ~/ruta/nombrearchivo.sql

  
    # Restaurar un backup de una base de datos
    psql -U usuario -h host -d database -f /ruta/fichero/copia.sql    

```

### Modo Consola

Para acceder a la consola Psql ejecutar el comando `psql` y opcioinalmente indicar un nombre de usuario
```
psql -U [username];
```

#### Ver usuarios desde modo consola
```
	\du 
	
```

#### Salir del modo consola
```
    \q
```

### Modo Gráfico

Un completo gestor gráfico es [pgAdminIII](https://www.pgadmin.org/) 

### Gestión de bases de datos y usuarios

#### Crear cuenta de usuario 


Los siguientes comandos para agregar o crear una cuenta de usuario y otorgar permiso para la base de datos:

```

    adduser – Comando Linux utilizado para agregar un usuario al sistema
    psql – El front-end para PostgreSQL en línea de comandos
    CREATE USER – Agregar un nuevo usuario al motor de base de datos PostgreSQL
    CREATE DATABASE nombre; – Crear una base de datos
    GRANT ALL PRIVILEGES – Definir privilegios de acceso
	ALTER ROLE nombreusuario WITH SUPERUSER; --> Hace un usuario superuser de postgresql
```

    
