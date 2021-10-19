## Instalar Odoo 12 en Debian 9 con SSL Lets Encrypt y Reverse Proxy NginX

Este tutorial cubre los pasos necesarios para instalar y configurar ODOO 12 usando el [código fuente de Odoo disponible en Git](https://github.com/odoo/odoo) y un entorno Python virtual (Probado con éxito en un sistema Debian GNU/Linux 9)

### Preliminares

#### Actualizar el sistema

Login en la máquina Debian GNU/Linux 9 como usuario sudo y actualiza el sistema:

```
sudo apt update && sudo apt upgrade
```

Instalar Git, Pip, Node.js y las dependencias requeridas de Odoo:

```
sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less
```

#### Crear Usuario Odoo12

Crear un nuevo usuario para Odoo llamado `odoo12` con el home directory en `/opt/odoo12` usando el siguiente comando:

```
sudo useradd -m -d /opt/odoo12 -U -r -s /bin/bash odoo12
```

#### Instalar y Configurar PostgreSQL

Instalar PostgreSQL desde los repositorios:

```
sudo apt install postgresql
```

Una vez que la instalación se complete, crear un usuario PostgreSQL con el mismo nombre que el usuario de sistema creado anteriormente , en nuestro caso es `odoo12`:

```
sudo su - postgres -c "createuser -s odoo12"
```

#### Instalar Wkhtmltopdf

El paquete wkhtmltox proporciona un conjunto de herramientas de código abierto las cuales pueden renderizar HTML en PDF y varios formatos de imágenes. Para poder imprimir en PDF los informes, es necesario el paquete wkhtmltopdf. la versión recomendada para Odoo es la 0.12.x que no viene incluida en los repositorios oficiales.

Descargar el paquete con este comando wget:
 
```
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb
```
wkhtmltox_0.12.5-1.stretch_amd64.deb

Una vez descargado descomprimir e instalar con los comandos:

```
apt install ./wkhtmltox_0.12.5-1.stretch_amd64.deb

```

### Instalar y Configurar Odoo

Instalaremos Odoo desde el repositorio GitHub dentro de un entorno virtual aislado Python.

Antes de empezar con el proceso de instalación cambiamos al usuario “odoo12”:

```
sudo su - odoo12
```

Clonamos el repositorio de github:

```
git clone https://www.github.com/odoo/odoo --depth 1 --branch 12.0 /opt/odoo12/odoo
```

Creamos un entorno virtual Python:

```
cd /opt/odoo12
python3 -m venv odoo-venv
```

A continuación, activamos el entorno con el siguiente comando:

```
source odoo-venv/bin/activate
```

Instalamos todos los módulos python requeridos por odoo con el comando `pip3`:

```
pip3 install wheel
pip3 install -r odoo/requirements.txt
```

Desactivar el entorno virtual con este comando:

```
deactivate
```

Crear un nuevo directorio para los addons:

```
mkdir /opt/odoo12/odoo-custom-addons
```

Cambiamos de nuevo al usuario sudo:

```
exit
```

A continuación, crearemos un fichero de configuración copiando el original como molde:

```
sudo cp /opt/odoo12/odoo/debian/odoo.conf /etc/odoo12.conf
```

abrimos el fichero y lo editamos para dejarlo como sigue:

```
sudo nano /etc/odoo12.conf

/etc/odoo12.conf

[options]
; This is the password that allows database operations:
admin_passwd = my_admin_passwd
db_host = False
db_port = False
db_user = odoo12
db_password = False
addons_path = /opt/odoo12/odoo/addons,/opt/odoo12/odoo-custom-addons
```

No te olvides de cambiar my_admin_passwd a algo mas seguro.

#### Crear un fichero Systemd Unit

Para ejecutar Odoo como un servicio necesitaremos crear un fichero de tipo service unit en la carpeta `/etc/systemd/system/`.

```
sudo nano /etc/systemd/system/odoo12.service
```

con este contenido

```
[Unit]
Description=Odoo12
Requires=postgresql.service
After=network.target postgresql.service
[Service]
Type=simple
SyslogIdentifier=odoo12
PermissionsStartOnly=true
User=odoo12
Group=odoo12
ExecStart=/opt/odoo12/odoo-venv/bin/python3 /opt/odoo12/odoo/odoo-bin -c /etc/odoo12.conf
StandardOutput=journal+console
[Install]
WantedBy=multi-user.target
```

Notificaremos a systemd que se ha agregado un nuevo fichero unit y arrancaremos el servicio odoo12 con:

```
sudo systemctl daemon-reload
sudo systemctl start odoo12
```

Chequea el estado del servicio:

```
sudo systemctl status odoo12
```

La salida debe indicar algo parecido a lo de abajo, indicando que el servicio está cargado (loaded) pero desactivado (disabled):

```
- odoo12.service - Odoo12
   Loaded: loaded (/etc/systemd/system/odoo12.service; disabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-10-09 14:15:30 PDT; 3s ago
 Main PID: 24334 (python3)
    Tasks: 4 (limit: 2319)
   CGroup: /system.slice/odoo12.service
           `-24334 /opt/odoo12/odoo-venv/bin/python3 /opt/odoo12/odoo/odoo-bin -c /etc/odoo12.conf
```

Para que arranque automaticamente en el inicio del sistema, lo activamos con:

```
sudo systemctl enable odoo12
```

Si quieres ver los mensajes del log guardados por el servicio Odoo puedes usar:

```
sudo journalctl -u odoo12
```

#### Test de la Instalación

Abre el navegador y ves a : http://your_domain_or_IP_address:8069

Asumiendo que todo haya ido bien, aparecerá la ventana de gestión de las bases de datos

#### Configure Nginx as SSL Termination Proxy

Ensure that you have met the following prerequisites before continuing with this section:

* Domain name pointing to your public server IP. In this tutorial we will use example.com.
* Nginx installed.
* SSL certificate for your domain. You can install a free Let's Encrypt SSL certificate .

The default Odoo web server is serving traffic over HTTP. To make our Odoo deployment more secure we will configure Nginx as a SSL termination proxy that will serve the traffic over HTTPS.

SSL termination proxy is a proxy server which handles the SSL encryption/decryption. This means that our termination proxy (Nginx) will handle and decrypt incoming TLS connections (HTTPS), and it will pass on the unencrypted requests to our internal service (Odoo) so the traffic between Nginx and Odoo will not be encrypted (HTTP).

Using a reverse proxy gives you a lot of benefits such as Load Balancing, SSL Termination, Caching, Compression, Serving Static Content and more.

In this example we will configure SSL Termination, HTTP to HTTPS redirection, WWW to non-WWW redirection, cache the static files and enable GZip compression.

Open your text editor and create the following file:

```
sudo nano /etc/nginx/sites-enabled/example.com
```

/etc/nginx/sites-enabled/example.com

```
# Odoo servers
upstream odoo {
 server 127.0.0.1:8069;
}

upstream odoochat {
 server 127.0.0.1:8072;
}

# HTTP -> HTTPS
server {
    listen 80;
    server_name www.example.com example.com;

    include snippets/letsencrypt.conf;
    return 301 https://example.com$request_uri;
}

# WWW -> NON WWW
server {
    listen 443 ssl http2;
    server_name www.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    include snippets/ssl.conf;

    return 301 https://example.com$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com;

    proxy_read_timeout 720s;
    proxy_connect_timeout 720s;
    proxy_send_timeout 720s;

    # Proxy headers
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;

    # SSL parameters
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    include snippets/ssl.conf;

    # log files
    access_log /var/log/nginx/odoo.access.log;
    error_log /var/log/nginx/odoo.error.log;

    # Handle longpoll requests
    location /longpolling {
        proxy_pass http://odoochat;
    }

    # Handle / requests
    location / {
       proxy_redirect off;
       proxy_pass http://odoo;
    }

    # Cache static files
    location ~* /web/static/ {
        proxy_cache_valid 200 90m;
        proxy_buffering on;
        expires 864000;
        proxy_pass http://odoo;
    }

    # Gzip
    gzip_types text/css text/less text/plain text/xml application/xml application/json application/javascript;
    gzip on;
}
```

Don’t forget to replace example.com with your Odoo domain and set the correct path to the SSL certificate files. The snippets used in this configuration are created in this guide .

Once you are done, restart the Nginx service with:

```
sudo systemctl restart nginx
```

Next, we need to tell Odoo that we will use proxy. To do so, open the configuration file and add the following line: /etc/odoo12.conf

```
proxy_mode = True
```

Restart the Odoo service for the changes to take effect:

```
sudo systemctl restart odoo12
```

At this point, your server is configured and you can access your Odoo instance at: https://example.com

\####Change the binding interface

This step is optional, but it is a good security practice.

By default, Odoo server listens to port 8069 on all interfaces. If you want to disable direct access to your Odoo instance you can either block the port 8069 for all public interfaces or force Odoo to listen only on the local interface.

In this guide we will configure Odoo to listen only on 127.0.0.1. Open the configuration add the following two lines at the end of the file: /etc/odoo12.conf

```
xmlrpc_interface = 127.0.0.1
netrpc_interface = 127.0.0.1
```

Save the configuration file and restart the Odoo server for the changes to take effect:

```
sudo systemctl restart odoo12
```

\####Enable Multiprocessing

By default, Odoo is working in multithreading mode. For production deployments, it is recommended to switch to the multiprocessing server as it increases stability, and make better usage of the system resources. In order to enable multiprocessing we need to edit the Odoo configuration and set a non-zero number of worker processes.

The number of workers is calculated based on the number of CPU cores in the system and the available RAM memory.

According to the official Odoo documentation to calculate the workers number and required RAM memory size we will use the following formulas and assumptions:

Worker number calculation

```
theoretical maximal number of worker = (system_cpus * 2) + 1
1 worker can serve ~= 6 concurrent users
Cron workers also requires CPU
```

RAM memory size calculation

```
We will consider that 20% of all requests are heavy requests, while 80% are lighter ones. Heavy requests are using around 1 GB of RAM while the lighter ones are using around 150 MB of RAM
Needed RAM = number_of_workers * ( (light_worker_ratio * light_worker_ram_estimation) + (heavy_worker_ratio * heavy_worker_ram_estimation) )
```

If you do not know how many CPUs you have on your system you can use the following command:

```
grep -c ^processor /proc/cpuinfo
```

Let's say we have a system with 4 CPU cores, 8 GB of RAM memory and 30 concurrent Odoo users.

```
30 users / 6 = **5** (5 is theoretical number of workers needed )
(4 * 2) + 1 = **9** ( 9 is the theoretical maximum number of workers)
```

Based on the calculation above we can use 5 workers + 1 worker for the cron worker which is total of 6 workers.

Calculate the RAM memory consumption based on the number of the workers:

```
RAM = 6 * ((0.8*150) + (0.2*1024)) ~= 2 GB of RAM
```

The calculation above show us that our Odoo installation will need around 2GB of RAM.

To switch to multiprocessing mode, open the configuration file and append the following lines: /etc/odoo12.conf

```
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
limit_time_cpu = 600
limit_time_real = 1200
max_cron_threads = 1
workers = 5
```

Restart the Odoo service for the changes to take effect:

```
sudo systemctl restart odoo12
```

The rest of the system resources will be used by other services that run on this system. In this guide we installed Odoo along with PostgreSQL and Nginx on a same server and depending on your setup you may also have other services running on your server. Conclusion

This tutorial walked you through the installation of Odoo 12 on Debian GNU/Linux 9 in a Python virtual environment using Nginx as a reverse proxy. You also learned how to enable multiprocessing and optimize Odoo for production environment.

###Referencias 

https://linuxize.com/post/how-to-deploy-odoo-12-on-ubuntu-18-04/

https://www.rosehosting.com/blog/how-to-install-odoo-12-on-debian-10-with-nginx-as-a-reverse-proxy/#Step-3-Install-wkhtmltopdf



### Autorenovar el certificado SSL de lets encrypt

En el cron del root incluir

    15 3 * * * /usr/bin/certbot renew --quiet
    20 3 * * 1 /etc/init.d/nginx reload
    

En el fichero del sitio de odoo en sites-enabled 

    location ^~ /.well-known/acme-challenge/ {
      allow all;
      root /var/lib/letsencrypt/;
      default_type "text/plain";
      try_files $uri =404;
    }

Mapear .well-known/acme-challenge a /var/lib/letsencrypt :

    #> sudo mkdir -p /var/lib/letsencrypt/.well-known
    #> sudo chgrp odoo12 /var/lib/letsencrypt
    #> sudo chmod g+s /var/lib/letsencrypt

### Tunear Nginx
Subir ficheros grandes en Odoo > 1.5 mb

Modificar el fichero /etc/nginx.conf 

agregar en http {
    ...
    client_max_body_size 100m;
}
