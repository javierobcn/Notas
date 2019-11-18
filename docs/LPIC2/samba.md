#Samba
##Instalación y documentación: 
 
Para instalar el servidor: `apt install samba`

Per instalar el cliente: `apt install cifs-útiles` y opcionalmente, `apt install smbclient` También existe el paquete `samba-doc`. Hay muchos ejemplos de configuración en `/usr/share/doc/samba-doc/htmldocs/index.html` y en la carpeta `/usr/share/doc/samba-doc/examples`. También el propio `smb.conf` tiene ejemplos. 

##Demonios y puesta en marcha

- **smbd** (escucha en los puertos TCP 135 y 445): comparte recursos y controla accesos

- **nmbd** (escucha en los puertos UDP / TCP 137,138 y 139): informa a la red de los recursos disponibles vía netbios

Haciendo simplemente `systemctl {start | stop} samba`, ya se ponen en marcha / paran ambos de golpe 

##Montar un servidor Samba

1. Suponiendo que utilicemos el esquema de seguridad "User" (el predeterminado), primero se deben crear en el servidor Linux los "usuarios Samba" (los cuales son usuarios propios de Samba que no están pensados ​​para iniciar sesión en Linux sinó solo para acceder a las carpetas compartidas vía Samba). Se crean así: 

    `useradd -s /sbin/nologin usuariSamba` # Una alternativa es usar /etc/samba/ smbusers (ver más abajo) 

    `smbpasswd -a usuariSamba` # Crea contraseña propia de Samba, no del sistema Linux.La contraseña, si se usa el "backend" llamado "tdbsam" (el predeterminado) se guarda en `/etc/samba/passdb.tdb`. De todas formas, se puede saber siempre donde se guarda exactamente haciendo `smbd -b` Si se quiere eliminar la contraseña Samba, simplemente hay que hacer `smbpasswd -x usuariSamba2`.

2. Confirmar que la configuración del servidor Samba, en el archivo `/etc/samba/smb.conf`, sea similar a esta: 
``` 
[global]
    interfaces=192.168.1.122/24 #Tarj de red donde samba escucha (necesita bind interface only=yes)        
    workgroup=nombreAgrupacionMaquinas  #Se puede poner cualquier nombre
    passdb backend = tdbsam:/ruta/passdb.tdb #Por defecto la ruta es /var/lib/samba/private (otro "backend"podria ser un servidor LDAP; entonces el valor de esta directiva sería ldapsam:ldap://x.x.x.x:nº)
    server role = standalone server  #otros valores servirían para federarlo con otros servidores      
    security = user  #Otros valores serían domain (para hacer de cliente AD; O sea que los usuarios no se validan contra el tdbsam local sinó contra un servidor de dominio dedicado a eso) o ads (para hacer de servidor AD)
```

3. Compartir las carpetas deseadas, indicando para cada una una sección, en el archivo `/etc/samba/smb.conf`, similar a: 
 
```
[lerelele] #El nombre que se ponga, inventado, será el que se usará para nombrar el recurso desde otras máquinas 
comment = "mi carpeta compartida" 
path = /ruta/real/carpeta/compartida 
writable = yes # También está "read only", que es la opción justo contraria. Los permisos del sistema cuentan, ojo !! # Es decir: para qué writable = yes funcione, el permiso del grupo "otros" de la carpeta en su disco duro debe ser rw 
# Se pueden definir los permisos de escritura más finamente, especificando una lista de usuarios Samba concretos que pueden # leer / escribir, con las directivas "write list = pepe juan, @ grupo" y "read list = pepe juan, @ grupo". Un ejemplo práctico 
# sería hacer un read_only = yes (para todos) y luego especificar usuarios concretos que pueden escribir. Hay que tener en 
# cuenta, no obstante, que al final siempre acaban aplicando los permisos de los ficheros correspondientes 
write list = pepe @grup #Llista los únicos usuarios capaces de escribir en la carpeta compartida (si writable = no) 
read list = pepe @grup #Llista los únicos usuarios capaces de leer en la carpeta compartida 
browseable = yes #Si vale no, sería como las carpetas compartidas ocultas de Windows -las que terminan en $ - 
create mask = 0700 #Los permisos que tendrán los nuevos archivos creados directory mask = 0700 #Los permisos que tendrán los nuevos subdirectorios creados 
guest ok = yes #Mode lectura, sin necesidad de usar ningún usuario / contraseña. Equivale a "public = yes" guest only = yes # Sólo funciona con guest ok. Se combina con force user si pueden escribir 
guest account = nombredelacuentadelsistemausadaenlosaccesosanonimos (normalmente, usuario nobody) 
valid users = pepe @grup # Únicos usuarios / grupos reconocidos por el servidor Samba. También hay "invalid users" 
hosts allow = 192.168.1.123, 127.0.0.0/8 EXCEPT 127.0.0.1 #Llista blanca de clientes permesos
hosts deny = 192.168.1.123, 127.0.0.0/8 EXCEPT 127.0.0.1 #Llista negra de clientes prohibidos (en caso de conflicto entre "hosts allow" y "hosts deny" gana "hosts allow"
```

Es muy importante tener en cuenta que no es suficiente con que el usuario tenga permisos de lectura / escritura en la carpeta compartida, sino que además debe tener permisos de entrar (-x) a todos las carpetas anteriores existentes en la ruta hasta llegar a la carpeta en cuestión 

!!!NOTE "Nota"
    En el archivo `/etc/samba/smb.conf` también está la sección predefinida [homes], la cual, entre otros, comparte automàticamente la carpeta personal de los usuarios Samba. La manera de acceder desde un cliente sería //ipServSamba/usuariSamba.

4. Reiniciar el servicio: `systemctl restart smbd`

El comando `testparm` comprueba si el archivo smb.conf está escrito correctamente (no tiene errores de sintaxis) .

El comando `smbstatus` comprueba el estado del servidor

Siempre se pueden consultar los logs del servidor general en los ficheros `/var/log/samba/log.{smbd,nmbd}`

##Acceder desde un cliente Linux a un servidor Windows / Samba 

* Para listar los recursos compartidos del servidor Windows / Samba:
 
    `smbclient -L //ipServSamba -U usuariSamba [-N (no passwd for guest)] `

* Cliente tipo FTP interactivo ( permite los comandos help, ls, cd, mget, mput, del, rm, mkdir, rename ...): 

    `smbclient // ipServSamba / recurso -U usuariSamba [contraseña]` 

* Para montar un recurso remoto en un punto de montaje local
 
    ```
    mount.cifs //ipServSamba/recurso  /ruta/punto/montaje/ local -o [guest] [, username = usuariSamba, password = contraseña] [, credentials = /ruta/archivo/con/logins], ro, port=nº 
    ```
    El archivo credentials debe tener permisos 600 con propietario root, y tiene una pinta como esta: 

    ```
    username=usuariSamba 
    password=contrasenya
    ```
    
    !!!NOTE "NOTA"
        a veces hay que añadir la opción vers = 1.0 para que el montaje funcione
    
    !!!NOTE "NOTA"
        Otras opciones interesantes son uid=nomUsuarioLocal y gid=nomGrupoLocal, las cuales permiten establecer el propietario y el grupo del punto de montaje al indicado (en vez de root, que sería lo normal al haber ejecutado el comando mount con sudo) 

* También se puede utilizar un gestor de ficheros cualquiera (Dolphin, Nautilus ...) y escribir en la barra de direcciones: `smb://usuariSamba: contraseña@ipServSamba/recurso` 
 
* También se puede montar la carpeta remota de forma automática en `/etc/ fstab`: 

    ```
       //ipServSamba/recurso /ruta/punto/montaje/local cifs username=..., password=..., [uid=..., gid=..., iocharset=utf8, ...] 0 0
    ```

    o para mayor seguridad: 

    ```
        //ipServSamba/recurso /ruta/punto/montaje/local cifs credentials=/ruta/archivo, [uid=..., gid=.. .,] 0 0
    ```


    Si no se quiere que se vea la contraseña que hay en `/etc/fstab`, se puede utilizar `/etc/samba/smbfstab`

!!!NOTE "Nota"
    Otras opciones interesantes son la combinación noauto, x-systemd-automount, las cuales permiten no montar automáticamente la carpeta en el arranque del sistema (donde podría darse el caso de que la red todavía no estuviera operativa) sino en el momento en que el usuario quiera acceder por primera vez (que esto ocurrirá una vez ya ha iniciado sesión y ya esté todo en marcha) 

* Para desmontar: `smbumount /ruta/punto/montaje/local`
