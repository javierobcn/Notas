# Docker
##Instalación de Docker

1. Verificar que no hay nada de docker anteriormente instalado
    
    sudo apt remove docker docker-engine docker.io containerd runc

2.Actualizamos la máquina

    sudo apt update

3. Por defecto, APT no usa HTTPS, así que instalamos los siguientes paquetes

        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

4. Agregamos la clave GPG de docker

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

5. Verificamos que la clave gpg fue instalada correctamente

        sudo apt-key fingerprint 0EBFCD88

6. En el caso de Docker hay 3 versiones disponibles: «Stable», ‘Nightly’ o ‘Test’, instalaremos la versión «stable» con el comando:

        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu
bionic stable"

7. Con el repositorio añadido, actualizamos la cache de APT

        sudo apt update
    
8. Por último instalamos la última versión de Docker CE y containerd.

        sudo apt install docker-ce docker-ce-cli containerd.io

9. Ejecutamos el siguiente comando para verificar que se ha instalado todo correctamente

        sudo docker run hello-world


10. Para evitar errores de permisos deberemos agregar nuestro usuario al grupo Docker

        sudo usermod -a -G docker $USER
     
##Comandos Docker básicos

Listar Imágenes disponibles en local

    docker images
    
Ejecutar una imagen (en este caso postgres) dentro de un container descargándola si es necesario

    docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db postgres
    
    -d  ejecuta el container en background e imprime el id del container

!!!help

    –name db  este parámetro asigna el nombre db al container
    
    -e  Parámetros al container. El container de odoo lee estos parametros automaticamente
    postgres –> Nombre de la imagen que se va a ejecutar

Ver que containers hay en ejecución

    docker ps
    
Ejecutar una imagen en un container

    docker run -p 8069:8069 --name odoo --link db:db -t odoo:9.0
    
!!!help

    -p 8069:8069 –> hace disponible en local el puerto 8069, de forma que veremos odoo en 127.0.0.1:8069
    
    –link db:db –> Dentro del docker de Odoo se establece una referencia a db que especifica el servidor de BD que se va a usar
    
    -t odoo:9.0 –> Se descarga la V 9 pero podría ser otra como la 12    
    