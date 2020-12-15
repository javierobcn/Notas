## Instalar un servidor DLNA para «AllShare» de Samsung en Linux

MiniDLNA es un servidor DLNA compatible con televisores Samsung y otras marcas. Este standard te permite acceder desde el televisor a las carpetas compartidas que tengas en el PC y de esa forma ver tus contenidos en el televisor.

##Mi equipo

* Televisor Samsung LED Series 5 (Compatible con DLNA)
* Router de Telefónica
* Equipo de sobremesa con Linux Ubuntu 12.04 LTS

##Conexiones

Partimos de que tengas bien configurada tu red, preferiblemente todo con IP’s fijas

* El televisor, lo he conectado a la red doméstica con un PLC
* El ordenador de sobremesa conectado directamente al Router
* El 2º PLC conectado al Router

##Instalando MiniDLNA en Linux Ubuntu 12.04 LTS.

MiniDLNA es un software que, instalado en un ordenador, nos permite compartir ciertas carpetas con tus contenidos (Fotos, videos, musica…) y así puedes ver en el televisor esos contenidos.

* Descargar los fuentes de la última versión de MiniDLNA desde http://sourceforge.net/projects/minidlna/files/minidlna/

y descomprimirlos en una carpeta temporal. La misma carpeta de descargas sirve.

* Los siguientes pasos se realizan desde el terminal, puedes copiar y pegar las órdenes… ejecuta el siguiente comando para quedarte como administrador:

    sudo su

Instalar los fuentes de las librerías necesarias para la compilación:

    apt-get install libavutil-dev libavcodec-dev libavformat-dev
    libflac-dev

Mas fuentes…:

    apt-get install libvorbis-dev libid3tag0-dev libexif-dev
    libjpeg62-dev libsqlite3-dev

Compilar

    ./configure; make; make install

Copiar el script de arranque a init.d

    cp linux/minidlna.init.d.script /etc/init.d/minidlna

Cambiar los permisos del script

    chmod 755 /etc/init.d/minidlna

Declarar que se arranque en todos los niveles

    update-rc.d minidlna defaults

Modificar el archivo de configuración

    sudo gedit /etc/minidlna.conf

En el archivo de configuracion, cambiar el directorio o directorios que se van a compartir y que serán accesibles desde el servidor.

Descomentar la linea donde asigna la tarjeta de red y que viene comentada por defecto. Si no lo haces, el servicio DLNA no arrancará automaticamente cuando inicies Linux

Para arrancar el servidor por primera vez:

    /etc/init.d/minidlna start
    
Una vez arrancado el servidor, en la televisión, seleccionas el botón de entrada y podrás ver el pinguino de Linux.

##Recursos

* https://help.ubuntu.com/community/MiniDLNA
* http://sourceforge.net/projects/minidlna/files/minidlna
* http://es.wikipedia.org/wiki/Digital_Living_Network_Alliance
* http://www.dlna.org/

