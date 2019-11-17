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
    
    /ruta/carpeta/compartida nomDNS.maquina.desdedondese.accede (opciones) otramáquina (opciones) ...


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
        El propietari i el seu grup (i, com a conseqüència, "els altres" i tots els seus corresponents permisos) que la màquina client "veu" associats a cada fitxer exportat pel servidor són el propietari i grup que a la màquina client tingui el seu mateix UID i GID que el propietari i grup "reals" del fitxer a la màquina servidora. Això vol dir si a la màquina client no hi ha cap usuari que tingui un UID/GID igual al del propietari/grup "real" al servidor, el fitxer en qüestió no es reconeixerà amb propietari/grup vàlid.