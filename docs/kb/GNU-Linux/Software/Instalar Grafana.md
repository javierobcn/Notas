# Instalar Grafana

Instalar la última versión Open Source OSS release:

	sudo apt-get install -y apt-transport-https
	sudo apt-get install -y software-properties-common wget
	wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

Agregar este repositorio a las fuentes para versiones estables:

	echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

Después de agregar el repositorio:

	sudo apt-get update
	sudo apt-get install grafana

Arrancar el servicio y verificar que todo es correcto

	sudo systemctl daemon-reload
	sudo systemctl start grafana-server
	sudo systemctl status grafana-server

tiene que decir algo como

● grafana-server.service - Grafana instance
   Loaded: loaded (/lib/systemd/system/grafana-server.service; disabled; vendor 
   Active: active (running) since Tue 2020-12-08 00:09:48 CET; 6s ago
     Docs: http://docs.grafana.org

Configurar el servicio de grafana para que arranque al inicio

	sudo systemctl enable grafana-server.service


### Configurar grafana con SSL

modificar el fichero de configuracion quitando los ; de las lineas donde modifiquemos los valores

		[server]
		# Protocol (http or https)
		protocol = https

		# The public facing domain name used to access grafana from a browser
		domain = veeamtech.ddns.net

		# Redirect to correct domain if host header does not match domain
		# Prevents DNS rebinding attacks
		enforce_domain = true

		# https certs & key file
		cert_file = /etc/letsencrypt/live/veeamtech.ddns.net/cert.pem
		cert_key = /etc/letsencrypt/live/veeamtech.ddns.net/privkey.pem

La ruta de los certificados puede ser diferente, por ej. en un servidor con HestiaCP instalado la ruta de los certificados podría ser /usr/local/hestia/ssl/ y para que el usuario de grafana tuviera permisos habría que incluirlo en alguno de los grupos que pueden acceder a los certificados.

Para hacer login por primera vez  ir a  https://nombredelhost:3000/

usuario y password --> admin

Hacer Click en OK y cambiar la clave por una mas robusta.


Fuente
https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository
