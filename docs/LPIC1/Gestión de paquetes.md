#Gestión de paquetes
##Formatos

RPM → Formato desarrollado por Red Hat

DEB → Formato desarrollado por Debian

Un fichero deb o rpm es un fichero comprimido con información como autor, versión, tags, dependencias, con que es incompatible etc… es una forma de distribuir el software y su instalación en el sistema.

##Instaladores de paquetes

    apt
    apt-get
    aptitude
    dselect
    Synaptic - en modo gráfico
    dpkg es el último escalón, todos acaban tirando de dpkg

`apt-get` → comando para instalar programas que están en los repositorios, los repositorios están definidos en el fichero `/etc/apt/sources.lst`, se puede modificar este fichero a manija pero entonces es necesario realizar un `apt-get update` para act. la bd local.

Formato del fichero:

```   
    deb → paquetes precompilados para debian
    URL → de donde descargará el paquete
    main → forma parte del core debian
    contrib → contribuciones
    non-free → No de libre distribución
    deb-src → código fuente
```

```
    # deb cdrom:[Debian GNU/Linux 8.5.0 _Jessie_ - Official Multi-architecture amd64/i386 NETINST #1 20160604-19:56]/ jessie main

    #deb cdrom:[Debian GNU/Linux 8.5.0 _Jessie_ - Official Multi-architecture amd64/i386 NETINST #1 20160604-19:56]/ jessie main

    deb http://ftp.es.debian.org/debian/ jessie main
    deb-src http://ftp.es.debian.org/debian/ jessie main

    deb http://security.debian.org/ jessie/updates main
    deb-src http://security.debian.org/ jessie/updates main

    # jessie-updates, previously known as 'volatile'
    deb http://ftp.es.debian.org/debian/ jessie-updates main
    deb-src http://ftp.es.debian.org/debian/ jessie-updates main
```

###Comandos básicos

`apt-get update` → cuando cambiemos el fichero de repositorios para cargar las nuevas listas

`apt-get upgrade` → actualiza paquetes

`apt-get -source` → obtiene el paquete con el código fuente en /usr/src

`apt-get dist-upgrade` → actualiza la distribución, ojo que es un proceso complejo y puede no funcionar.

`apt-get install algo` → para instalar un paquete, se descarga automáticamente en /var/cache/apt/archives 

`apt-get clean` → para borrar la cache de archivos descargados por instalación

`apt-cache search autocad` → buscar aplicaciones disponibles en los repositorios

`Aptitude` → es como synaptic en modo texto

`aptitude search` → buscar aplicaciones, solo busca en el nombre por lo que se recomienda usar apt-cache search 

No se puede verificar la autenticidad del repositorio X

En este caso será necesario agregar la clave PGP al sistema.

    :::bash
    wget -o “http://ur.donde.llave” | apt-get key add - #(el - cogerá la llave  del wget)

##Instalación de un paquete que no está en los repositorios

`wget paquete debian` → obtenemos el paquete 

`dpkg -L paquete` → ver lo que va a instalar en el disco

lo instalamos con:
`dpkg -i nombrepaquete`


si aparecen errores de dependencias, la instalación se quedará en un estado inconsistente, para solucionarlo ejecutamos:

    :::bash
    apt-get -f install # arreglará problemas de dependencias al instalar un paquete con dpkg y lo dejará ya instalado.

`dpkg -r` →  para eliminar un paquete

`dpkg -l` →  para listar los paquetes instalados (ii quiere decir instalado y ir installed removed)

`dpkg -l | grep -i figlet`

### Ejemplo - Monitorix
Monitorix es un software para monitorizar servidores disponible en www.monitorix.com

descargamos desde la web el paquete debian o bien hacemos un wget

    dpkg -i /home/javier/Descargas/monitorix_3.8.1-izzy1_all.deb

A mitad de la instalación nos dirá que necesita Perl y unas cuantas librerias y dependencias, con lo que la operación quedará sin terminar. Para resolver los problemas de instalación ejecutamos
    
    :::bash
    apt-get -f install # finalizar el proceso de instalación.


###Ejemplo 2 Elastic Search

Por ej. para instalar Elastic Search tendremos diferentes alternativas:

- Descargamos de su web el fichero .deb

- Incluimos en los repositorios:
        
        :::bash
        wget -o “https://packages….” | apt-key add -
		echo “deb https://packages…. debian stable main | tee -a /etc/apt/elasticsearch.list

Es habitual tener los repositorios separados:

    sources.list.d/elasticsearch.list

basta colocarlos en la carpeta `sources.list.d` y se realizará su inclusión

!!! note "Nota"
    Los paquetes ubuntu en debian y viceversa puede hacerse pero no es lo mas recomendable, podría haber discrepancias.

Se pueden convertir paquetes RPM a deb y viceversa con una herramienta llamada `alien`

Según el fabricante de software es posible encontrar siempre la ultima versión siguiendo una norma por ej. WordPress siempre tiene el mismo fichero /latest.tar.gz que permite su inclusión en un script.

##[Mas comandos relacionados](/LPIC1/Comandos%20Linux/#gestion-de-paquetes-deb-debian-ubuntu-y-otros)


##Software para automatización de infraestructura

Ansible

puppet

cheff

recomendable ansible, curva de aprendizaje menor que en puppet y es muy complejo.
