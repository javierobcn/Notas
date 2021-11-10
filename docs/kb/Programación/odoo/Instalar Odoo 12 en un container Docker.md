# Instalar Odoo 12 en un container Docker

En este tutorial se crearán 2 containers:

* 1 container para la base de datos
* 1 container para ODOO

Además para garantizar la persistencia de los datos, se usarán volumenes de datos Docker, uno para que Postgres guarde la base de datos y otros dos para que odoo guarde ficheros adjuntos, módulos extra, datos de sesión etc.

## Configuración de red Docker

Creamos una red Docker para conectar nuestra base de datos y Odoo

    docker network create --driver bridge sgw-odoo-nw

Creamos el container postgresql 11.1

    docker run -d --name sgw-db \
    --env POSTGRES_USER=odoo --env POSTGRES_PASSWORD=sgw-clave-secret \
    --env POSTGRES_DB=postgres \
    --network=sgw-odoo-nw --mount source=sgw-db-data,target=/var/lib/postgresql/data \
    library/postgres:11.1    

Se chequea con este comando el log del container y debe decir algo como «LOG: database system is ready to accept connections»

    docker logs sgw-db

## Container y volúmenes para ODOO

    docker volume create --name sgw-odoo-data
    docker volume create --name sgw-odoo-extra-addons
     
    docker run -d --name sgw-odoo --link sgw-db:db -p 8069:8069 \
    --network sgw-odoo-nw \
    --mount source=sgw-odoo-data,target=/var/lib/odoo \
    --mount source=sgw-odoo-extra-addons,target=/mnt/extra-addons \
    --env POSTGRES_PASSWORD=sgw-clave-secret \
    veivaa/odoo:12.0

En lugar de la imagen veivaa/odoo:12.0 puede usarse también la imagen oficial disponible en library/odoo:12.0.

Se chequean los logs y debe decir algo como
    «2018-10-07 16:37:55,491 1 INFO ? odoo.service.server: HTTP service (werkzeug) running on 95d90feba5bf:8069»

    docker logs unkkuri-odoo

Acceder a Odoo desde

    http://localhost:8069

### Correr y detener containers

Ver los containers corriendo actualmente

    docker ps

Ver todos los containers

    docker ps -a

Detener un container  

    docker stop sgw-odoo

Correr container

    docker start sgw-odoo

tras reiniciar el ordenador o Docker, tendremos los containers detenidos por lo que habrá que arrancarlos con:

    docker start sgw-db
    docker start sgw-odoo

Puede establecerse a "Always" la política restart para evitar este comportamiento.

## Actualizar Odoo

    docker stop sgw-odoo
    docker rm sgw-odoo
    docker pull veivaa/odoo:12.0
    docker run -d --name sgw-odoo --link sgw-db:db -p 8069:8069 \
    --network sgw-odoo-nw \
    --mount source=sgw-odoo-data,target=/var/lib/odoo \
    --mount source=sgw-odoo-extra-addons,target=/mnt/extra-addons \
    --env POSTGRES_PASSWORD=sgw-clave-secret \
    veivaa/odoo:12.0

## Borrar todo

    docker stop sgw-odoo
    docker rm sgw-odoo
    docker volume rm sgw-odoo-data
    docker volume rm sgw-odoo-extra-addons
     
    docker stop sgw-db
    docker rm sgw-db
    docker volume rm sgw-db-data
     
    docker network rm sgw-odoo-nw

## Backup/Restore a dockerized PostgreSQL database

<http://stackoverflow.com/questions/24718706/ddg#29913462>

Backup your databases

    docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

Restore your databases
  
  cat your_dump.sql | docker exec -i your-db-container psql -U postgres
