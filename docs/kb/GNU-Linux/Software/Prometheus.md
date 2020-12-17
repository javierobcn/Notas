
# Prometheus

## ¿Qué es Prometheus?

Prometheus es una aplicación de software de código abierto que se utiliza para la supervisión y alerta de eventos.  Registra métricas en tiempo real en una base de datos de series de tiempo (que permite una alta dimensionalidad) construida utilizando un modelo de extracción HTTP, con consultas flexibles y alertas en tiempo real. El proyecto está escrito en Go y tiene licencia de Apache 2 License, con código fuente disponible en GitHub.

## ¿Cómo instalar Prometheus en un servidor Linux?

### Requisitos

Abrir el puerto 9090 en el firewall

Actualizar el sistema con 

	sudo apt-get update && sudo apt-get upgrade

Descargar el último binario desde la página de Prometheus

	cd /tmp
	wget https://github.com/prometheus/prometheus/releases/download/v2.23.0/prometheus-2.23.0.linux-amd64.tar.gz

Descomprimirlo

	tar -xvf prometheus-2.23.0.linux-amd64.tar.gz

Renombrar la carpeta

	mv prometheus-2.23.0.linux-amd64 prometheus-files


### Instalación

Crear un usuario, los directorios requeridos y hacer que el usuario sea el propietario de esos directorios:

	sudo useradd --no-create-home --shell /bin/false prometheus
	sudo mkdir /etc/prometheus
	sudo mkdir /var/lib/prometheus
	sudo chown prometheus:prometheus /etc/prometheus
	sudo chown prometheus:prometheus /var/lib/prometheus

Copiar prometheus y el binario promtool desde la carpeta prometheus-files a /usr/local/bin y cambiar el propietario al usuario prometheus.

	sudo cp prometheus-files/prometheus /usr/local/bin/
	sudo cp prometheus-files/promtool /usr/local/bin/
	sudo chown prometheus:prometheus /usr/local/bin/prometheus
	sudo chown prometheus:prometheus /usr/local/bin/promtool

Mover los directorios consoles y console_libraries desde prometheus-files a /etc/prometheus y cambiar el propietario al usuario prometheus.

	sudo cp -r prometheus-files/consoles /etc/prometheus
	sudo cp -r prometheus-files/console_libraries /etc/prometheus
	sudo chown -R prometheus:prometheus /etc/prometheus/consoles
	sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

### Configurar Prometheus

La configuración de Prometheus se hace desde el fichero /etc/prometheus/prometheus.yml .

#### Crear el fichero de configuración prometheus.yml.

	sudo nano /etc/prometheus/prometheus.yml

Copiar el siguiente contenido al fichero prometheus.yml

	global:
		scrape_interval: 10s

	scrape_configs:
		- job_name: 'prometheus'
			scrape_interval: 5s
			static_configs:
				- targets: ['localhost:9090']

Cambiar el propietario del fichero de configuración al usuario prometheus

	sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

#### Configurar el servicio Prometheus

Crear un fichero de servicio.

	sudo nano /etc/systemd/system/prometheus.service

Copiar el siguiente contenido dentro del fichero

	[Unit]
	Description=Prometheus
	Wants=network-online.target
	After=network-online.target

	[Service]
	User=prometheus
	Group=prometheus
	Type=simple
	ExecStart=/usr/local/bin/prometheus \
			--config.file /etc/prometheus/prometheus.yml \
			--storage.tsdb.path /var/lib/prometheus/ \
			--web.console.templates=/etc/prometheus/consoles \
			--web.console.libraries=/etc/prometheus/console_libraries

	[Install]
	WantedBy=multi-user.target

Recargar el servicio systemd para registrar el servicio prometheus y iniciarlo.

	sudo systemctl daemon-reload
	sudo systemctl start prometheus

Chequear el  status usando.

	sudo systemctl status prometheus

El status debe mostrar algo parecido a:

	● prometheus.service - Prometheus
	   Loaded: loaded (/etc/systemd/system/prometheus.service; enabled; vendor preset: enabled)
	   Active: active (running) since Mon 2020-12-07 19:41:02 CET; 2h 8min ago

Activar el servicio para que se cargue en el arranque
	
	sudo systemctl enable prometheus.service

### Acceder al Web UI de Prometheus

Ahora debe poder accederse al interfaz web de Prometheus en la dirección

	http://<prometheus-ip>:9090/graph

Hasta ahora se ha configurado el servidor Prometheus. Será necesario registrar los targets en el fichero prometheus.yml file para obtener las métricas desde las fuentes de datos.

Po ejemplo, si se quieren monitorizar 10 servidores, las direcciones IP de esos servidores deberán añadirese como "target" en el fichero de configuración para que el servidor haga scraping de los datos.

El servidor a monitorizar debe tener "Node Exporter" instalado y disponible para que Prometheus lo visite y adquiera los datos.


Fuentes
https://devopscube.com/install-configure-prometheus-linux/

	
## Cómo monitorizar servidores Linux usando Prometheus Node Exporter

### Requisitos

Port 9100 opened in server firewall as Prometheus reads metrics on this port.

### Instalar Node Exporter Binary

- Descargar el último paquete de node exporter. Chequear cual es la última versión en la sección Downloads del sitio web de prometheus y adaptar el siguiente comando.

	cd /tmp
	wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz

- Descomprimir el fichero descargado

	tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz

- Mover el binario node-exporter a /usr/local/bin

	sudo mv node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/

!!! note "Nota:"
    En el momento de escribir este artículo, la última versión era node_exporter-1.0.1.linux-amd64 pero esto puede cambiar y hay que ir a buscar siempre la última versión en github o en la seccion downloads del sitio web  de prometheus

### Crear un servicio personalizado

- Crear un usuario node_exporter para ejecutar el servicio
	
	sudo useradd -rs /bin/false node_exporter

- Crear un servicio de tipo systemd para node_exporter

	sudo nano /etc/systemd/system/node_exporter.service

- El fichero de servicio ha de tener el siguiente contenido
```
	[Unit]
	Description=Node Exporter
	After=network.target

	[Service]
	User=node_exporter
	Group=node_exporter
	Type=simple
	ExecStart=/usr/local/bin/node_exporter --web.listen-address="127.0.0.1:9100"

	[Install]
	WantedBy=multi-user.target
```

!!! note "Nota:"
    El ejecutable node_exporter admite distintos parámetros a la hora de lanzarlo, algunos parámetros interesantes son por ej. **--web.listen-address** el cual especifica en que tarjeta de red y puerto se ha de mantener a la escucha el exportador de datos, al decirle 127.0.0.1 evitamos que el resultado del exporter sea público, luego haremos mediante un proxy nginx cargaremos esta dirección solo desde determinadas IP.

- Recargar y iniciar el servicio node_exporter

	sudo systemctl daemon-reload
	sudo systemctl start node_exporter

- Chequear el status del servicio

	sudo systemctl status node_exporter

- Activar el servicio para que se arranque en el inicio

	sudo systemctl enable node_exporter

- Ahora node exporter estará exportando métricas en el puerto 9100 solo para el localhost. Podemos hacer un wget desde la misma máquina y comprobar desde la red externa que el sitio no es accesible 
```
	cd /tmp
	wget http://127.0.0.1:9100/metrics
	cat /tmp/index.html 
```

### Proteger por IP y hacer accesible con proxy Nginx

Creamos un sitio en nginx para el exporter

	sudo su
	nano /etc/nginx/sites-available/open_exporter

Definimos el servidor con este contenido
	
```
server {
    listen       9101;
    location / {
        allow 192.168.1.10;
        deny all;
        proxy_pass http://localhost:9100;
    }
}

```

!!! note "Nota:"
    En el ejemplo, la directiva allow restringe el acceso a la ip 192.168.1.10
	
habilitamos el sitio creando un enlace en la carpeta sites-enabled

	ls -s /etc/nginx/sites-avaiable/open_exporter /etc/nginx/sites-enabled/open_exporter

reiniciamos nginx

	systemctl restart nginx

###Configurar el servidor a monitorizar como target en Prometheus

!!! note "Nota:"
    Esta configuración ha de realizarse en el servidor Prometheus


Modificar el fichero de configuración prometheus.yml 

	sudo nano /etc/prometheus/prometheus.yml

En la sección scrape añadir el node exporter target como se muestra debajo, cambiando la IP 192.168.1.11 por la IP del servidor donde se haya configurado el node exporter. El nombre del Job puede ser cualquiera, es a efectos de identificación.

	...
	- job_name: 'node_exporter_metrics'
	  scrape_interval: 5s
	  static_configs:
	    - targets: ['192.168.1.11:9100']

Reiniciar el servicio prometheus para que los cambios surjan efecto.

	sudo systemctl restart prometheus


### Configurar Blackbox exporter para métricas web, DNS y otros interesantes

	
Descargar BlackBox Exporter

Ir a la página oficial para obtener el último binario disponible. Yo estoy descargando blackbox_exporter-0.18.0.linux-amd64.tar.gz

https://github.com/prometheus/blackbox_exporter/releases


Descargar y extraer
	
	sudo su
	cd /tmp
	wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.18.0/blackbox_exporter-0.18.0.linux-amd64.tar.gz
	tar -xzf blackbox_exporter-0.18.0.linux-amd64.tar.gz
	mv blackbox_exporter-0.18.0.linux-amd64 blackbox_exporter
	mv blackbox_exporter /usr/local/bin

Dentro de la carpeta blackbox_exporter hay 2 ficheros importantes:
    
    blackbox_exporter: Ejecutable para el servicio
    blackbox.yml: Fichero de configuración para blackbox donde se definen los chequeos.

Algunos flags que pueden usarse.

./blackbox_exporter -h

	--config.file="blackbox.yml" Blackbox exporter configuration file.

	--web.listen-address=":9115" The address to listen on for HTTP requests.

	--timeout-offset=0.5 Offset to subtract from timeout in seconds.

	--config.check If true validate the config file and then exit.

	--history.limit=100 The maximum amount of items to keep in the history.

Crear usuario para Blackbox y asignar permisos

	sudo useradd -rs /bin/false blackbox
	sudo chmod -R 777 /usr/local/bin/blackbox_exporter
	sudo chown -R blackbox:blackbox /usr/local/bin/blackbox_exporter

Crear servicio para blackbox
	
	sudo nano /etc/systemd/system/blackbox.service

con este contenido

	[Unit]
	Description=Blackbox Exporter Service
	Wants=network-online.target
	After=network-online.target

	[Service]
	Type=simple
	User=blackbox
	Group=blackbox
	ExecStart=/usr/local/bin/blackbox_exporter/blackbox_exporter --config.file="/usr/local/bin/blackbox_exporter/blackbox.yml" --web.listen-address="127.0.0.1:9115"

	[Install]
	WantedBy=multi-user.target

Activamos el servicio y lo probamos

	sudo systemctl daemon-reload
	sudo systemctl start blackbox.service
	sudo systemctl enable blackbox.service
	sudo systemctl status blackbox.service


	wget http://localhost:9115/ 

Integrando blackbox con prometheus

Vamos a monitorizar github.com

	sudo nano /etc/prometheus/prometheus.yml

agregamos el job

```
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: ['http_2xx'] # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - https://github.com
        - https://google.com
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115 # The blackbox exporter's real hostname:port.
```

Reiniciamos Prometheus

	sudo systemctl restart prometheus.service


https://github.com/prometheus/blackbox_exporter
https://geekflare.com/monitor-website-with-blackbox-prometheus-grafana/
	
	
