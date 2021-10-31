# Docker

En cierto modo ofrece lo mismo que una máquina virtual pero sin la carga de trabajo que conlleva instalar, configurar y administrar una máquina virtual.

* Permite ejecutar aplicaciones en un entorno aislado que es independiente de la máquina en la que se ejecuta.

* Cuando se trabaja en múltiples proyectos, permite aislar  y evitar potenciales inconsistencias o conflictos entre ellos.

* Hace posible que todas las dependencias que necesite el proyecto estén disponibles 


## Imagenes
Una imagen es una plantilla para crear el entorno que necesitemos. Es un "snapshot" de un sistema, habitualmente con una app o servicio instalado. Hay imágenes de Ubuntu, Debian, Apache, Nginx, Postgres, PHP, Python .... también es posible crear nuevas imágenes.

### Crear una imagen "Hola Mundo"

```bash
mkdir ejemplos_docker
cd ejemplos_docker
mkdir src
touch src/index.php
echo '<?php echo "Hola Mundo";' >> src/index.php
```

en ese directorio creamos un fichero llamado "Dockerfile" sin extensión, dentro ponemos:

```
FROM php:7.0-apache
COPY src/ /var/www/html
EXPOSE 80
```

Ahora, se crea la imagen con el comando:

```bash
docker build -t hola-mundo .
```
Observamos la salida

```bash
Sending build context to Docker daemon  3.584kB
Step 1/3 : FROM php:7.0-apache
 ---> aa67a9c9814f
Step 2/3 : COPY src/ /var/www/html
 ---> f30d645e8a3d
Step 3/3 : EXPOSE 80
 ---> Running in 4b6d47709756
Removing intermediate container 4b6d47709756
 ---> 4b1c49a9bb2b
Successfully built 4b1c49a9bb2b
Successfully tagged hola-mundo:latest
```

tras lo cual la imagen quedará disponible para ejecutar con el comando

```bash
docker run -p 80:80 hola-mundo
```
Accediendo a http://localhost veremos el resultado.

Si el fichero "src/index.php", ubicado en la máquina anfitrión, cambia, lógicamente en la imagen docker no cambiará ya que esta imagen es un "snapshot" al que se copió el fichero en el momento de la creación. Aquí entran en juego los volúmenes

## Volúmenes
Un volumen permite compartir datos entre el anfitrión donde se ejecuta el contenedor y el propio contenedor. Esto se hace a través de una carpeta, ubicada físicamente en el anfitrión y montada dentro del contenedor, siendo posible entonces acceder a dichos ficheros en tiempo real.

Detengamos el container pulsando control + c en la ventana donde se está ejecutando

y ahora lo volvemos a ejecutar agregando el parámetro -v como sigue:

```bash
docker run -p 80:80 -v /home/javier/vs-projects/ejemplos_docker/src:/var/www/html hola-mundo
```

!!!Info
    En el parámetro -v se indica primero la ruta en el host local y separada por ":" la ruta en el container.

!!!Warning
    El container está ligado al proceso que ejecuta de manera que si ese proceso muere, el container se detiene, es por eso que un container debe contener solo un proceso.


## Contenedores
Un contenedor no es una máquina virtual, ya que una máquina virtual tendría todos los servicios, el sistema operativo, incluyendo su propio kernel, y esto hace que las máquinas virtuales sean pesadas. El contenedor, en cambio, ocupa muchos menos recursos, arranca mas rápido y es mas eficiente en cuanto al uso de disco y de memoria. Un contenedor es una instancia en ejecución de una imagen. 

Por ej. una imagen de postgresql y otra imagen de odoo pueden ejecutarse simultaneamente usando menos espacio y menos memoria que si lo instalaramos en una máquina virtual todo junto. Además, en una máquina virtual, la configuración de postgresql y odoo supondría varias horas de trabajo, mientras que con Docker esto puede hacerse mucho más rápido y de forma mas eficiente.

## Docker Compose

```bash
mkdir tutorial
cd tutorial
mkdir product
cd product
nano product.py
```
ponemos dentro

```python

    from flask import Flask
    from flask_restful import Resource, Api

    app = Flask(__name__)
    api = Api(app)

    class Product(Resource):
        def get(self):
            return {
                'product':  ['Ice cream',
                             'Chocolate',
                             'Fruta']
            }

    api.add_resource(Product,'/')

    if __name__=='__main__':
        app.run(host='0.0.0.0',port=80,debug=True)

```


## Instalación

Lo ideal sería usar la versión que incluya la distribución de linux que estés usando y instalar con

```bash
sudo apt-get install docker
```
o mediante el programa de software de tu distro

En caso de que no se incluya docker por ser una versión antigua pueden seguirse estos pasos:

1. Verificar que no hay nada de docker anteriormente instalado
```
sudo apt remove docker docker-engine docker.io containerd runc
```

2. Actualizamos la máquina
```
sudo apt update
```

3. Por defecto, APT no usa HTTPS, así que instalamos los siguientes paquetes
```
sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
```
4. Agregamos la clave GPG de docker
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

5. Verificamos que la clave gpg fue instalada correctamente
```
sudo apt-key fingerprint 0EBFCD88
```
6. En el caso de Docker hay 3 versiones disponibles: «Stable», ‘Nightly’ o ‘Test’, instalaremos la versión «stable» con el comando:
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
```

7. Con el repositorio añadido, actualizamos la cache de APT
```
sudo apt update
```
8. Por último instalamos la última versión de Docker CE y containerd.
```
sudo apt install docker-ce docker-ce-cli containerd.io
```
9. Ejecutamos el siguiente comando para verificar que se ha instalado todo correctamente
```
sudo docker run hello-world
```

10. Para evitar errores de permisos deberemos agregar nuestro usuario al grupo Docker
```
sudo usermod -a -G docker $USER
```

## Post-instalación en Linux

Después de instalar Docker, el demonio Docker queda unido a un Socket, por defecto este Socket es propiedad del usuario root y el resto de usuarios solo pueden acceder como sudo. El demonio de Docker siempre se ejecuta como el usuario root.

Para evitar tener que poner sudo en todos los comandos, se crea un grupo Docker y se añaden los usuarios a ese grupo.
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
docker run hello-world
```
### Configurar Docker para arrancar al inicio

Docker ya crea un servicio Systemd, con lo que solo hay que hacer enable para que arranque al inicio del sistema.
```
sudo systemctl enable docker
```
Si quisieramos deshabilitarlo
```
sudo systemctl disable docker
```

https://docs.docker.com/engine/install/linux-postinstall/

## Comandos Docker básicos

### Listar Imágenes disponibles en local
```
docker images
```
### Mostrar información sobre la instalación de docker
```
docker info
```
### Ejecutar una imagen dentro de un container descargándola si es necesario

En este caso postgres
```
docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db postgres
```    

!!!Note
    -d  ejecuta el container en background e imprime el id del container

    -name db  este parámetro asigna el nombre db al container
    
    -e  Parámetros al container. El container de odoo lee estos parametros automaticamente
    postgres –> Nombre de la imagen que se va a ejecutar

Ver que containers hay en ejecución
```
    docker ps
``` 
Ejecutar una imagen en un container
```
docker run -p 8069:8069 --name odoo --link db:db -t odoo:9.0
``` 
!!!help

    -p 8069:8069 –> hace disponible en local el puerto 8069, de forma que veremos odoo en 127.0.0.1:8069
    
    –link db:db –> Dentro del docker de Odoo se establece una referencia a db que especifica el servidor de BD que se va a usar
    
    -t odoo:9.0 –> Se descarga la V 9 pero podría ser otra como la 12    
    
## Enlaces interesantes

https://www.youtube.com/watch?v=YFl2mCHdv24
