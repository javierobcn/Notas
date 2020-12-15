#VestaCP

##VestaCP ftp 530 Login incorrect

El servidor siempre devuelve un error Login incorrect con las cuentas FTP recién creadas.

Esto sucede por que se les asigna a los usuarios ftp el login /usr/sbin/nologin (Esto se puede comprobar en /etc/passwd)

Y ese login no está registrado en los shells en el fichero /etc/shells

Por lo que añadiendo la linea /usr/sbin/nologin al fichero /etc/shells se soluciona el problema

## Agregar certificado let’s Encrypt a Vesta

Partiendo de una instalación estandard donde Vesta CP está funcionando en el puerto 8083 y podemos acceder a https://maquina.example.com:8083

Buscamos, Vesta CP el sitio web correspondiente a maquina.example.com , si no existe lo creamos, aunque lo mas probable es que ya exista bajo la cuenta admin

Activamos Let’s encrypt para el sitio web correspondiente a maquina.example.com , esto nos generará los certificados y vesta se encargará de renovar los certificados de forma automática.

los certificados quedarán generados en la carpeta /home/admin/conf/web/ y serán dos ficheros el crt y el .key ambos con el nombre del dominio y comenzando por ssl.

    cat /home/admin/conf/web/ssl.maquina.example.com.crt
    cat /home/admin/conf/web/ssl.maquina.example.com.key
    
Ahora se han de establecer unos symlinks para el sitio vesta cp que tenemos corriendo en el puerto 8083 , y enlazarlo para que use los certificados creados para el sitio web en el paso anterior y en el puerto 80. Previamente podemos renombrar los certificados existentes. Después dejamos los permisos como estaban para los certificados anteriores.
    
    mv /usr/local/vesta/ssl/certificate.crt /usr/local/vesta/ssl/unusablecer.crt
    mv /usr/local/vesta/ssl/certificate.key /usr/local/vesta/ssl/unusablecer.key
    ln -s /home/admin/conf/web/ssl.maquina.example.com.crt /usr/local/vesta/ssl/certificate.crt
    ln -s /home/admin/conf/web/ssl.maquina.example.com.key /usr/local/vesta/ssl/certificate.key
    chown root:dovecot certificate.crt
    chown root:dovecot certificate.key
    
Listo, ahora cuando el certificado se renueve para el sitio corriendo en el puerto 80, el sitio vesta cogerá esos certificados.

## Instalar WordPress en Vesta

* Se crea el usuario en vestacp, el sitio web, la base de datos y el correo
* Se descarga en local la ultima copia de wordpress desde https://es.wordpress.org/
* Se descomprime en local y se copia el archivo wp-config-sample.php como wp-config.php.
* Se extrae un conjunto de claves desde https://api.wordpress.org/secret-key/1.1/salt/ y se colocan en el wp-config.php
* Se ponen en el wp.config las siguientes lineas para evitar que pida datos FTP en las actualizaciones:

    define('FTP_USER', 'usuarioftp');
    define('FTP_PASS', 'claveftp');
    define('FTP_HOST', 'ipservidor');

    Se suben a la carpeta web del servidor «public_html» los archivos descomprimidos

* Se accede al dominio para comenzar la instalación
* En la instalación escoger un nombre de usuario robusto que no sea el del mismo dominio
* Se crea un archivo .htaccess con el contenido

    Options All -Indexes
 
 y se le dan permisos (777) . Después vas a tu panel de administrador de wordpress y definimos los permalinks
 
* Se crea una carpeta wp-content/uploads y se le dan permisos a la carpeta uploads