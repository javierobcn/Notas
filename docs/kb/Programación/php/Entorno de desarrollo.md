# Entorno de desarrollo para php (NetBeans)

!!!Warning
    Este documento es antiguo y puede estar caducado en algunos aspectos, pero puede servir de referencia para otras cosas.

En este tutorial se muestra cómo instalar un entorno de desarrollo PHP en Debian / Ubuntu.

La máquina de desarrollo tendrá instalado:

* Apache
* MySQL
* PHP
* phpMyAdmin
* NetBeans IDE
* XDebug

##Instalar LAMP

Para instalar el stack LAMP se ejecuta el siguiente comando desde el terminal:
    
    apt-get install phpmyadmin mysql-server php5-mysql

!!! info 
        phpMyAdmin es un software, desarrollado en PHP, que permite gestionar el servidor MySQL desde el navegador web.
        Instalar phpMyAdmin es una forma rápida de instalar Apache y las librerias necesarias para ejecutar aplicaciones PHP. En la instalación también se incluye el servidor MySQL y las librerías del sistema necesarias para acceder desde PHP a MySQL.


Durante la instalación se preguntará:

* Contraseña del usuario de administración de la base de datos. Es la clave que se asignará al usuario root MySQL (no tiene nada que ver con el usuario root de la máquina). Anota la clave y no la pierdas.
* Contraseña de aplicación MySQL para phpmyadmin. Registrará phpMyAdmin con el servidor de bases de datos. Anota la clave y no la pierdas.
* Sobre que servidor web deseamos ejecutar phpMyAdmin, en este paso responder Apache

* ¿Desea configurar la base de datos para phpmyadmin con «dbconfig-common»? Si

Una vez finalizada la instalación, navegue a  http://localhost/phpmyadmin para ver la pantalla de login, podemos usar root y la clave que hayamos especificado para entrar.


##Instalación de NetBeans

NetBeans es un IDE (Entorno integrado de Desarrollo) para Java, C, PHP y otros lenguajes.

Descargamos desde https://netbeans.org/downloads/ el paquete específico para PHP en versión 32 bits o 64 bits según nuestra arquitectura de máquina.

Hacemos ejecutable el archivo descargado con el comando:

    chmod +x netbeans-8.1-php-linux-x64.sh

 

Nos impersonamos como root y ejecutamos el archivo descargado:

    su –
    ./netbeans-8.1-php-linux-x64.sh

 
Siguiente, siguiente, siguiente….

 

Por defecto se instalará en /usr/local/netbeans-8.1

 

Probamos que arranca bien desde el lanzador de apps.


## Virtual Host para el primer proyecto

Para simular lo máximo posible un entorno de producción la idea es que los proyectos se ejecuten sobre apache en la máquina local, para ello se ha de configurar un virtual host que aloje el primer proyecto. Llame a este proyecto proyecto1.localhost

nos impersonamos como usuario root:

    sudo su

 Crear la carpeta raiz del proyecto en

    /var/www/html/proyecto1/public

 

Crear el fichero de virtual host en Apache

    /etc/apache2/sites-available/proyecto1.conf

Con el siguiente contenido:

    <VirtualHost *:80>
        ServerName proyecto1.localhost
        ServerAdmin correo@example.com
        DocumentRoot /var/www/html/proyecto1/public
        ErrorLog ${APACHE_LOG_DIR}/error-proyecto1.log
        CustomLog ${APACHE_LOG_DIR}/access-proyecto1.log combined
    </VirtualHost>

modifica ahora el fichero /etc/hosts y agrega una linea como esta:

    127.0.0.1 proyecto1.localhost

Activa el nuevo sitio con:

    sudo a2ensite proyecto1

reinicia apache con

    apache2ctl restart

Modificar el fichero de configuración de variables de entorno

    sudo nano /etc/apache2/envvars

En las lineas donde se establece el usuario que ejecuta apache en lugar de usar www-data use su propio nombre de usuario para evitar problemas derivados de la permisología. Esto solo debe hacerlo en su máquina de desarrollo.
 
    export APACHE_RUN_USER=www-data
    export APACHE_RUN_GROUP=www-data
 

Una vez hecho este cambio reinicie el servidor o si no está seguro todo el equipo


##Instalar el debugger PHP XDEBUG

Con XDEBUG y NetBeans podrá disponer de un completo debugger con el que ejecutar paso a paso, examinar el valor de las variables y otras comodidades.


Instalamos el paquete dpkg -L php5-xdebug para ver los ficheros instalados

    apt-get install php5-xdebug


Modificamos el fichero

    nano /etc/php5/mods-available/xdebug.ini

Agregamos estas líneas

    xdebug.profiler_output_dir=/tmp
    xdebug.profiler_output_name=cachegrind.out.%p
    xdebug.profiler_enable_trigger=1
    xdebug.profiler_enable=0
    xdebug.remote_enable=true
    xdebug.remote_host=127.0.0.1
    xdebug.remote_port=9001
    xdebug.remote_handler=dbgp
    xdebug.remote_autostart=0

Instala la extensión de NetBeans para el navegador que vayas a utilizar en el debug. Para chromium la extensión es:

https://chrome.google.com/webstore/detail/netbeans-connector/hafdlehgocfcodbgjnpecfajgkeejnaa

Si llegaste hasta aquí ya deberías tener un completo entorno de desarrollo, a partir de ahora para cada nuevo proyecto crearás un virtual host con su correspondiente entrada en el fichero hosts y listos.
