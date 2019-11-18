# Compartir ficheros con NFSv4

## Servidor

En Ubuntu debemos instalar el paquete **"nfs-kernel-server"** "y en Fedora el paquete **"nfs-utils"** (y opcionalmente el paquete **"nfs4-acl-tools"** que estudiaremos más adelante). Para comprobar si está bien instalado,
debería aparecer `nfs4` -y si es servidor, también `nfsd` - en la salida del comando `cat /proc/filesystems` (Comando que sirve para listar los sistemas de archivos reconocidos por el sistema)

!!!NOTE "Nota"
    En Fedora hay un paquete llamado "ganesha-nfs" que ofrece un servidor NFS diferente del clásico (no lo veremos) 

!!!NOTE "Nota"
    Para desactivar la capacidad de utilizar las versiones anteriores de NFS  (v2 y v3) en nuestro servidor -recomendable-, hay que tener las líneas vers2 = n y vers3 = n bajo la sección [nfsd] del archivo `/etc/nfs.conf`

Para compartir carpetas debemos modificar el contenido de un archivo (que puede no existir inicialmente) llamado `/etc/exports` (o añadir uno o más archivos con extensión ".exports" dentro de la carpeta `/etc/exports.d`). El
contenido del archivo `/etc/exports` (o los ubicados dentro de `/etc/exports.d`) debe ser una línea para cada carpeta que se quiera compartir ( "exportar"). El formato de la línea es así:


/ruta/carp/compartida nomDNS.maquina.desdedondese.accede (opciones) otramáquina (opciones)

donde:

* En lugar del nombre DNS de la máquina cliente permitida (el cual puede incluir los comodines *, ? y [ ]) se puede especificar su IP, o bien indicar redes completas con el formato ipRed/Mascara

* Después de cada nombre / ip de máquina / red deben aparecer las opciones de compartición; si hay varias se separan por comas, todas ellas dentro del paréntesis.
    
    !!! WARNING "ATENCIÓN"
        no se debe dejar ningún espacio en blanco entre el nombre / ip de máquina / red y el paréntesis de apertura: si se deja, querrá decir que estas opciones valen para todos los clientes y para el nombre / ip escrito aplicarán las opciones por defecto.

* Si la línea es demasiado larga se puede partir con el caracter \ .
Las opciones más importantes son (se pueden consultar muchas más en
`man exports`):

    |OPCION   |FUNCION   |
    |---|---|
    |**ro**   |Exportar en modo de sólo lectura. Este es el modo por defecto.|
    |**rw**   |Exportar en modo de lectura / escritura. Esto sólo significa que se aplicarán los permisos subyacentes de propietario, grupo y otros que tenga cada fichero exportado en particular. es decir, aunque hayamos especificado "rw" a una determinada carpeta en el archivo `/etc/exports`, no podremos escribir en ella si no tenemos además permisos de escritura sobre su punto de montaje al cliente (permisos que, de hecho, son copia de los permisos "Reales" de la carpeta en el servidor y que el cliente no se pueden modificar).|
    |||
    |**sync**   |En una escritura, el servidor NFS no responde al cliente hasta que los cambios no se han realizado físicamente en disco. Este es el modo por defecto.|
    |**async**|En una escritura, el servidor NFS responde al cliente antes de que los cambios se hayan realizado físicamente en disco. Esto permite un mejor rendimiento a costa de poder perder la integridad de los datos en un reinicie inesperado del servidor.

    !!!INFO "Info"
        El propietario y su grupo (y, como consecuencia, "los otros" y todos sus correspondientes permisos) que la máquina cliente "ve" asociados a cada archivo exportado por el servidor son el propietario y grupo que en la máquina cliente tenga su mismo UID y GID que el propietario y grupo "reales" del archivo en la máquina servidora. Esto quiere decir si en la máquina cliente no hay ningún usuario que tenga un UID / GID igual al del propietario / grupo "real" en el servidor, el archivo en cuestión no se reconocerá con propietario / grupo válido.

Por otra parte, en el caso de que la carpeta exportada tenga unos permisos que permitan escribir dentro, ¿quién será el propietario / grupo "real", en el servidor, de un fichero creado por un usuario local del cliente? depende de
las siguientes opciones:

|OPCION   |FUNCION   |
|---|---|
|**all_squash**|Los archivos creados por cualquier usuario de la máquina cliente tendrán como propietario / grupo "Real" en el servidor del usuario "nobody" (con UID especial 65534).|
|**no_all_squash** |Los archivos creados por cualquier usuario de la máquina cliente tendrán como propietario / grupo "Real" en el servidor del usuario que allí tenga el mismo UID / GID (si no hay ninguno, el archivo en cuestión no se reconocerá con propietario / grupo válido. Esta es la opción por defecto.|
|**root_squash**|Los archivos creados por el usuario "root" de la máquina cliente tendrán como propietario / grupo "Real" en el servidor del usuario "nobody" (con UID especial 65534). Esta es la opción por defecto.|
|**no_root_squash**|Los archivos creados por el usuario "root" de la máquina cliente tendrán como propietario / grupo "Real" en el servidor del usuario "root" del servidor. Esta opción es útil sobre todo para facilitar el arranque de sistemas PXE.
|**anonuid = 655**|En el caso de utilizar las opciones "all_squash" y / o "root_squash", permite especificar como usuario "nobody" uno con un UID concreto, distinto del predeterminado.
|**anongid = 655**|En el caso de utilizar las opciones "all_squash" y / o "root_squash", permite especificar como grupo "nobody" uno con un GID concreto, distinto del predeterminado.
|**fsid = 0**|Esta opción define la carpeta compartida que será la raíz a partir de la cual se compartirá todo lo que cuelgue de ella. Sólo puede haber una carpeta compartida con esta característica. Si se quiere compartir alguna otra carpeta (la llamaremos "/opt/otra") que no esté físicamente dentro de la marcada como fsid = 0 (la llamaremos "/Var/unacarpeta"), tenemos que hacer unos pasos previos:

-Debemos montar "/opt/unaaltra" dentro de "/var/unacarpeta/unasubcarpeta" (que supondremos inicialmente vacía), de forma que podamos acceder a la primera a través de la segunda. Esto se puede hacer de dos maneras: 

- la primera es temporal hasta que se reinicie la máquina servidora y la segunda es permanente. La primera consiste en ejecutar el comando: `mount --bind /opt/otra/var/unacarpeta/unasubcarpeta` 

- La segunda consistiría en añadir una línea tal como la siguiente al final del archivo de texto `/etc/fstab` (Ver más adelante para una explicación más profunda de este archivo):
    
        /opt/otra nohide crossmnt /var/unacarpeta/unasubcarpeta none bind 0 0

2.-Una vez hecho este montaje de tipo "bind", tenemos que añadir una línea en `/etc/exports` indicando que se quiere compartir `/var/unacarpeta/unasubcarpeta`; en esta línea es obligatorio indicar la opción "nohide" (explicada seguidamente).


|OPCION   |FUNCION   |
|---|---|
|**nohide**|Si se comparte una carpeta A como fsid = 0 dentro de la cual hay una subcarpeta B montada dentro de A con la opción --bind, para compartir explícitamente la carpeta B en `/Etc/exports` se debe especificar esta opción; si no se hace (o si se especifica la opción "hide"),B aparecerá vacía a los clientes.|
|**crossmnt**|Poner "crossmnt" en A equivale a poner "nohide" en B (y en todas las otras posibles subcarpetas que estén montadas bajo A con --bind|

Una vez configurado el archivo `/etc/exports`, ya podemos iniciar el servicio con el comando `sudo systemctl start nfs-kernel-server` (Ubuntu) o `sudo systemctl start nfs-server` (en Fedora). Recordemos que cada vez que
modificamos el archivo `/etc/exports` tendremos que reiniciar el servidor.

!!!NOTE "Nota"
    El puerto en el que escucha un servidor NFS es en el 2049 (tcp); hay que tenerlo en cuenta por el cortafuegos. Una manera rápida de abrir el puerto en cuestión sería ejecutar (en Fedora), los siguientes comandos: `sudo firewall-cmd --add-service = nfs --permanent && sudo firewall-cmd --reload`


El comando `sudo exportfs` muestra una lista de los sistemas exportados actualmente (añadiendo el parámetro -v lo hace en modo verboso). También se puede usar su parámetro -r para hacer lo mismo que `sudo systemctl reload nfs-kernel-server` Otros parámetros importantes de este comando son:


- El parámetro `-u ipClient:/rutaCarpeta` : permite desactivar la compartición de una carpeta concreta.
- El parámetro `-o opc, iones ipClient::/rutaCarpeta` : añade "al vuelo" una nueva compartición (que durarà hasta el próximo reinicio del servidor) para el cliente y las opciones indicadas
* El parámetro `-i -o opc, iones ipClient:/rutaCarpeta`: ignora completamente el archivo `/etc/exports` y entonces sólo comparte la carpeta indicada. Esto serviría para hacer pruebas rápidas sin tener que tocar el archivo `/etc/exports`.

El comando `nfsstat` muestra estadísticas de uso del servidor.

## Cliente

En Ubuntu debemos instalar el paquete `nfs-common` y en Fedora el paquete `nfs-utils`. Para comprobar si está bien instalado, debería aparecer "nfs4" al ejecutar `cat /proc/filesystems` (comando que sirve para listar
los sistemas de ficheros reconocidos por el sistema)

Para ver qué carpetas compartidas tiene un servidor, se puede ejecutar: `showmount -e ipservidor`

Para acceder a una carpeta compartida por el servidor (si no es fsid = 0), el cliente debe montarla previamente así:

`sudo mount -t nfs4 ipservidor:/ruta/carpeta/compartida/al/servidor /punto/local/de/montaje`

!!! NOTA "Nota"
    En vez de `mount -t nft4` se puede usar el alias `mount.nfs4.`


Para acceder a la carpeta compartida por el servidor con fsid = 0 (es decir, en la carpeta raíz, o dicho de otro manera, en la carpeta "/"), el cliente debe montar previamente:

`mount -t nfs4 ipservidor://punto/local/de/montaje`

Para acceder a una carpeta compartida montada en el servidor con el método "bind" bajo la carpeta raíz (es decir, bajo la marcada con fsid = 0), tendremos que indicar su ruta relativa desde esta carpeta raíz (pero,
eso sí, indicando la "/" inicial). Por ejemplo, si la carpeta raíz es `/var/unacarpeta` y se quiere compartir la carpeta `/opt/unaaltra` que está montada en el servidor dentro `/var/unacarpeta/unasubcarpeta`, el cliente debe
montarla así:
``` bash
mount -t nfs4 ipservidor:/unasubcarpeta /punto/local/de/montaje
```
En cualquier caso, para comprobar si el montaje se ha realizado correctamente, podemos ejecutar el comando `findmnt` o bien el comando `df`. En ambos casos tendremos que ver la presencia del nuevo punto de montaje, al que podremos acceder normalmente vía cd, listar su contenido vía ls, etc.

A la hora de hacer el montaje con el comando mount, se pueden indicar diferentes opciones específicas de NFS4 con el parámetro -o (ver man nfs para muchas más) ...:

!!!NOTE "Nota"
    Estas opciones también se pueden escribir dentro del archivo `/etc/nfsmount.conf` (ver man nfsmount.conf para mas información)


|Opción|Función|
|------|-------|
|**retry=n**|Indica los minutos durante los que se intentará montar una carpeta mientras no se consiga se sigue intentando hasta que se acabe el tiempo|
|**timeo=n**|en una operación de lectura / escritura, indica las décimas de segundos que el cliente esperará a recibir una respuesta del servidor antes de volver a intentar la misma operación. Por defecto es 600|
|**timeo=n**|en una operación de lectura / escritura, indica las décimas de segundos que el cliente esperará a recibir una respuesta del servidor antes de volver a intentar la misma operación. Por defecto es 600|
|**retrans=n**|En una operación de lectura / escritura, indica el número de veces que el cliente intentará realizar la misma operación. Por defecto es 3|
|**soft / hard**|Al llegar al límite de intentos indicado por la opción retrans, el valor "soft" hace que el cliente desista de continuar realizando la operación de lectura / escritura pendiente. El valor "hard", en cambio, hace que el cliente vuelva a intentarlo indefinidamente (en otras palabras, mantiene la petición del cliente aunque el servidor esté caído, para seguirla cuando éste recomience). Por defecto es "hard".|
|**wsize = n / rsize = n**|Indica el número (múltiple de 1024, y como máximo 1.048.576) de bytes que se pueden escribir / leer como máximo en una sola operación. Por defecto los valores son autonegociados entre cliente y servidor. Este dato afecta al rendimiento.
|**port = 2055**|Conecta a un servidor NFS que está escuchando a otro puerto diferente del estándar (2049)|

... además de las opciones generales que aporta el comando mount (ver `man mount` para muchas más), como:

|Opción|Función|
|------|-------|
|**ro**|Monta en modo de solo lectura (Read Only), por defecto los montajes se hacen en modo lectura/escritura ("rw")|
|**noatime**|No cambia la fecha de último acceso a los archivos. Esta fecha se guarda junto con más datos (como la fecha de última modificación, o la de creación, etc) en una "base de datos" de ficheros llamadas "inodes". Por defecto (opción "ATIME"), en cada acceso a un archivo la fecha de último acceso se cambia, pero con esta opción esto no se hace, acelerando así el acceso al disco.|
|**nodiratime**|No cambia la fecha de último acceso a los directorios. La opción contraria (y por defecto) es "**diratime**".|

!!!NOTE "Nota"
  Por ejemplo, el comando `mount.nfs4 -o ro, port=2000,soft,retry=4 ip:/ruta/remota /ruta/local` monta en "/ruta/local" la carpeta "/ruta/remota" existente en el servidor "ip" en modo sólo lectura (ro), conectándose al puerto 2000 del servidor y estableciendo el número de intentos para realizar las operaciones en 4, después de los cuales, se informará de error y no se continuará intentándolo.

No obstante, tener que escribir el comando mount a mano cada vez que queremos acceder a una carpeta compartida no es muy práctico (además de que lo tenemos que hacer como administrador). Lo más habitual es montar durante el arranque del cliente las carpetas compartidas que se quieran utilizar para tenerlas así disponibles inmediatamente por cualquier usuario del sistema cliente que inicie sesión (sea o no administrador), sin tener que hacer nada. Para hacer esto, el cliente debemos modificar un archivo de texto llamado `/etc/fstab`. Este archivo, de hecho, no es únicamente utilizado para NFS, sino que es mucho más general: contiene todos los tipos de almacenes a montar en el arranque del sistema (particiones locales, carpetas Samba, etc, etc).

Cada línea de este archivo consta de seis campos separados por un espacio en blanco o un tabulador (para más información, consultar `man fstab`):

* El 1º campo indica la partición / carpeta compartida concreta que deberá montar durante el arranque del sistema operativo (por ejemplo, la partición local `/dev/sda1` o una carpeta compartida remota NFS)

* El 2º campo indica la ruta de la carpeta que funcionará como su punto de montaje local

* El 3º campo indica el sistema de archivos en los que está formateada la partición / carpeta compartida (Valores posibles son: ext4, xfs, jfs, vfat -por "fat32" -, ntfs, swap, o auto -por no especificar ningún sistema en concreto y que el fstab el determine él solo en el momento del montaje ... esta opción es útil para lectores de unidades extraíbles como CD / DVDs que pueden contener diferentes sistemas de ficheros dependiendo de la unidad introducida-)
* El 4º campo indica las opciones de montaje se aplican (separadas por comas)
* El 5º campo actualmente no se utiliza y casi siempre vale 0
* El 6º campo indica si el comando fsck se ejecutará al reiniciar el sistema cuando se monte esta partición / carpeta compartida (un valor 0 significa que no se comprueba el sistema de ficheros, un valor 1 quiere decir que sí y un valor 2 significa que sí, pero después de haber comprobado las particiones marcadas con valor 1; normalmente la partición raíz del sistema debe tener un 1 mientras el resto de particiones puede tener un 0 o un 2) .Las opciones de montaje pueden ser cualquiera de las opciones específicas de NFS4 (las listadas en `man nfs`) o bien cualquiera de las generales del comando mount (es decir, las que están listadas en `man mount`). Entre estas últimas, hay algunas que tienen más sentido dentro de "/etc/fstab" que en un comando mount normal:

|Opción|Función|
|------|-------|
|**auto**|Indica que la partición / carpeta compartida correspondiente se montará automáticamente durante el arranque. En otras palabras: es la manera "de activar" esta línea. La opción contraria es "noauto", que sirve para "desactivar" la línea sin tener que borrarla, haciendo que sólo se pueda montar la partición / carpeta compartida correspondiente de forma manual con el comando mount o bien sí se combina con la opción "x-systemd.automount" (ver más abajo)|
|**exec**|Permite que se puedan ejecutar los binarios existentes en la partición / carpeta compartida correspondiente. La opción contraria es "noexec".|
|**suid**|Permite reconocer el permiso especial "suid" en los binarios existentes en la partición / carpeta compartida correspondiente. Este permiso especial se utiliza para permitir a usuarios que no son administradores ejecutar binarios que en teoría sólo podría ejecutar el usuario administrador (como el binario `passwd`, por ejemplo). La opción contraria es "**nosuid**"|
|**dev**|Permite reconocer los archivos de dispositivos que puedan existir en la partición / carpeta compartida correspondiente. La opción contraria es "nodev".|
|**user**|Permite que cualquier usuario (sin ser administrador) pueda montar con el comando mount la partición / carpeta compartida correspondiente (pero sólo el usuario que lo haya montado la podrá desmontar). Esta opción implica "noexec", "nosuid" y "nodev", a no ser que se indique lo contrario. La opción contraria (es decir, que sólo el usuario root pueda montar la partición / carpeta compartida correspondiente) es "nouser"|
|**users**|Permite que cualquier usuario (sin ser administrador) pueda montar con el comando mount la partición / carpeta compartida correspondiente, y también que cualquier otro usuario (o el mismo) la pueda desmontar. Esta opción implica "noexec", "nosuid" y "nodev", a no ser que se indique lo contrario.|
|**sync**|Hace que las escrituras a la partición / carpeta compartida correspondiente se realicen de forma síncrona (es decir, que se apliquen inmediatamente) .La opción contraria es "async", lo cual implica que las escrituras se realicen de forma asíncrona (es decir, que todas las escrituras se apliquen de golpe pasado un tiempo determinado). Estas opciones en NFS no se utilizan porque no se establecen en el cliente sino en el servidor a la hora de compartir la carpeta dentro de "/etc/exports" (Son opciones homónimas, de hecho).|
|**defaults**|Equivale a "rw", "suid", "dev", "exec", "auto", "nouser" y "async" x-systemd.automount Esta opción se debe escribir junto con la opción "noauto". Sirve para no montar la partición / carpeta compartida correspondiente en el arranque del sistema sino cuando el usuario quiera acceder por primera vez (el retraso es imperceptible). esto permite no tener montadas unidades que quizás el usuario no utilizará en esa sesión, y además permite no obtener errores al arrancar el cliente si en ese momento el servidor no está disponible. Se puede utilizar además la opción "x-systemd.device-timeout = n", donde n es el número de segundos que el cliente intentará montar el dispositivo antes de abandonar (porque éste no esté disponible, por ejemplo). No obstante, sólo funciona para sistemas con systemd.|

En el caso concreto de montar carpetas compartidas NFS, el primer campo (que, recordemos, representa el recurso a montar) se escribe indicando la ip/nombre del servidor NFS seguido de ":" y de la ruta en el servidor de la carpeta compartida a la que se quiere acceder (que será "/" en el caso de ser la carpeta fsid = 0 o "/unasubcarpeta" si "unasubcarpeta" es el punto de montaje -bind bajo ella). Por lo tanto, un ejemplo de archivo `/etc/fstab` para un
cliente NFS podría ser este:
``` bash
ipServ:/ruta/comp/servidor /punto/montaje nfs4 noauto,x-systemd.automount 0 0
```