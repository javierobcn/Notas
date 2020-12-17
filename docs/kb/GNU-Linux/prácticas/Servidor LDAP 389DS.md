##Servidor LDAP 389DS
###Configuración previa
Los pasos a seguir para configurar un servidor 389DS que contenga la información necesaria para [autenticar/identificar] usuarios (y los pasos a seguir para configurar un cliente LDAP para que esos usuarios accedan a ella) se detallan a continuación.

Deberás utilizar dos máquinas virtuales Fedora: una de ellas hará de servidor LDAP y la otra hará de cliente. Asegúrate que ambas tengan, además de una tarjeta en modo NAT para poder conectarse a Internet, una tarjeta en modo red interna con una [IP fija] (en este documento supondremos que tienen la 192.168.0.1 y 192.168.0.2, respectivamente) y de que la máquina que haga de cliente tenga instalado un entorno gráfico con navegador y gestor de ficheros (bastará hacer `sudo dnf install gdm firefox nautilus` para ello).

###Servidor    
A.  Antes de instalar nada, a la máquina que hará de servidor LDAP dale un nombre que tenga una estructura similar a un nombre DNS (por ejemplo, en este documento usaremos el de `miservidor.midominio.local`). De hecho, la infrastructura básica de una red con servidor LDAP integrado se debería completar con un servidor DNS más pronto que tarde (para, entre otras cosas, no tener que configurar el archivo `/etc/hosts` de los clientes individualmente -como tendremos que hacer más adelante-), pero para no complicar más las cosas, realiza estos tres simples pasos y ya está:

1. -Ejecuta el comando `sudo hostnamectl set-hostname miservidor.midominio.local`. Esto hará que el fichero `/etc/hostname` contenga el nuevo nombre “tipo DNS” de nuestro servidor (lo puedes comprobar también con el comando `hostnamectl status`).
    
2. Modifica manualmente el archivo `/etc/hosts` para que las IP 127.0.0.1 (v4) y ::1 (v6) allá indicadas estén asociadas a “miservidor.midominio.local” en vez de a “localhost”.

3. Una vez hecho estos dos pasos, reinicia la máquina.

!!!NOTE "Nota"
    Que el nombre del servidor sea de tipo DNS es necesario para que las entradas “dc” de nuestro servidor LDAP se correspondan con los subdominios de dicho nombre. Es decir, al generar la base de datos de nuestras entradas en forma de árbol invertido, todas ellas deberán colgar de un DN base que en nuestro caso será `“dc=midominio,dc=local”`.

####Instalación

Instala el software correspondiente a un servidor LDAP básico: 
```
sudo dnf install 389-ds-base
```

!!!NOTE "Nota"
    Otros paquetes interesantes són "389-admin" (el cual representa un "servidor de administración", útil para gestionar determinadas tareas relacionadas con el funcionamiento del servidor LDAP -como pararlo, reiniciarlo, hacer copias de seguridad, etc-) y/o "389-console" (el cual incluye a su vez los paquetes "389-ds-console" y "389-admin-console" y sirve para, respectivamente, ofrecer una interfaz gráfica (basada en Java) para trabajar contra el directorio alojado en el servidor LDAP como un cliente LDAP estándar -es decir, para gestionar la información guardada:añadiendo/eliminando/modificando nodos, etc- o bien para trabajar contra el servidor de administración anteriormente mencionado ordenándole las tareas administrativas de forma gráfica). También existe el paquete "389-ds" (el cual incluye todos los paquetes anteriores).

####Configuración inicial 
Configura el servidor LDAP propiamente dicho para poderlo empezar a usar. Para ello primero crea un fichero INF (llamémoslo "fichero.inf"), el cual tendrá un contenido ya predeterminado, mediante el comando `dscreate create-template /ruta/fichero.inf` . Este fichero INF representa un "molde" que podremos editar a conveniencia con cualquier editor de texto para asignar los valores deseados a las distintas directivas allí presentes. Estas directivas están perfectamente documentadas dentro del propio fichero y son bastante obvias; de todas maneras, como todas ellas ya tienen un valor por defecto asignado, nosotros tan solo necesitaremos editar unas pocas. En concreto, deberemos tener las siguientes directivas escritas como sigue:

!!!NOTE "Nota"
    Hay que tener en cuenta que si se desea cambiar el valor por defecto de una directiva, además de modificar el valor en sí, para activar el cambio efectivamente se tendrá de borrar el punto y coma que hay al inicio de la directiva en cuestión.

-  **Directiva instance_name=miservidor**: Para indicar que la instancia del servidor 389 a crear se llamará "miservidor" (aunque podría tener cualquier otro nombre). En un mismo ordenador podemos tener diferentes instancias del servidor 389DS, cada una independiente de la otra, gestionando cada una su/s propio/s directorio/s estancos y administrándose de forma individual. Cada instancia tendrá que definirse en un fichero INF diferente
-  **Directiva root_dn = cn=admin** : Indica que el "common name" del usuario administrador del directorio manejado por la instancia en cuestión será "cn=admin".Por defecto este usuario es el único que puede hacer tanto modificaciones como consultas en los directorios de servidores 389DS.
-  **Directiva root_password = 12345678** : Indica que la contraseña del usuario administrador anterior será "12345678". Si no se quisiera escribir la contraseña en texto plano directamente en el fichero INF, existe la posibilidad de generar previamente un hash adecuado mediante el comando pwdhash contraseña. Mínimo 8 caracteres
y entonces asignar el valor mostrado por pantalla tal cual a esta directiva
-  **Directiva create_suffix_entry = true** : Indica que se desea crear una entrada raíz en el directorio 
-  **Directiva suffix = dc=midominio,dc=local** : Indica que el nombre de la entrada raíz del directorio a crear será "dc=midominio,dc=local"

!!!NOTE "Nota"
    NOTA: El fichero INF contiene, tal como hemos dicho, muchas otras directivas que no será necesario editar si no lo deseamos porque ya deberían tener asignado el valor adecuado , como por ejemplo **full_machine_name** (cuyo valor debería ser el nombre completo de la máquina establecido en el primer apartado, es decir, en nuestro caso: "miservidor.midominio.local"), **port** (cuyo valor por defecto es 389; si se indica el valor 0 se estaría cerrando el puerto, esto es, deshabilitando la posibilidad de atender conexiones no encriptadas), **secure_port** (cuyo valor por defecto es 636; si se indica el valor 0 se estaría cerrando el puerto, esto es, deshabilitando la posibilidad de atender conexiones encriptadas via TLS) o **self_sign_cert** (cuyo valor por defecto, True, activa el uso de TLS para asegurar las comunicaciones por red con los clientes, y lo hace mediante certificados autofirmados), entre otras. Además, son interesantes reconocer diversas directivas que apuntan a rutas de carpetas relevantes, como "backup_dir", "cert_dir", "config_dir" o "db_dir" (esta última es la que aloja los ficheros que contienen físicamente los datos del directorio)

!!!NOTE "Nota"
    NOTA: Las líneas create_suffix_entry y suffix del fichero INF se encuentran bajo una sección titulada `[backend-userroot]` Los "backend" son los tipos de bases de datos que el servidor 389DS soporta para almacenar de forma permanente la información contenida en los directorios que gestiona; en este caso, la sección indica que se creará un backend llamado "userroot". Puede haber muchos tipos de backends, por lo que en 389DS se utiliza un mecanismo de plugins para solamente utilizar el/los plugin/s necesario/s para gestionar el/los backend/s correspondiente/s. El tipo de backend empleado por defecto por 389DS es la base de datos de tipo LDBM, que es una variante de las de tipo BerkeleyDB (las cuales todas ellas son implementadas físicamente en forma de ficheros en disco). En el archivo "dse.ldif" (ver siguiente apartado) se encuentra la información sobre la configuración del backend asociado a un directorio (bajo la sección `dn:dc=midominio,dc=local, cn=mapping tree, cn=config`) y sobre la propia configuración de ese backend elegido, bajo la sección dc: `cn=ldbm database,cn=plugins,cn=config` y `dc: cn=config,cn=ldbm database,cn=plugins,cn=config` Para más información consultar https://www.port389.org/docs/389ds/design/architecture.html y también el cuadro siguiente:

    ![Screenshot](media/ldap1.jpg)

A continuación utiliza el fichero INF generado en el paso anterior como entrada en el siguiente comando : `sudo dscreate from-file /ruta/fichero.inf`

Este comando establece realmente la configuración de la instancia "miservidor" en un formato que el servidor LDAP entenderá (concretamente, genera el archivo
de configuración `/etc/dirsrv/slapd-miservidor/dse.ldif`, el cual contiene todas las directivas indicadas en el fichero INF anterior -con alguna variación en su nombre- además de muchas otras más; todas las directivas
presentes en este fichero `dse.ldif` tienen la particularidad de estar escritas en un formato de texto llamado LDIF, el cual estudiaremos más adelante pero básicamente lo que hay que saber ahora es que esto significa
que este fichero puede ser modificado igualmente mediante cualquier editor de texto estándar).

!!! note "Nota"
    Una manera de editar el fichero "dse.ldif" es, en vez de utilitzar un editor de texto genérico, utilizar el comando específico de 389DS llamado dsconf; concretamente, para cambiar la contraseña del usuario "admin" usando esta herramienta se podría hacer (de forma interactiva y, eso sí, conociendo la contraseña previa) así: dsconf -D "cn=admin" miservidor directory_manager password_change . Otra manera sería, ya que el fichero "dse.ldif" no deja de ser un fichero LDIF estándar, utilizar los comandos estándar de edición de ficheros LDIF como es principalmente el comando ldapmodify, que veremos pronto (https://directory.fedoraproject.org/docs/389ds/howto/howto-resetdirmgrpassword.html#use-ldapmodify )

!!! note "Nota"
    Otra manera alternativa de configurar el servidor LDAP es usando el comando `sudo dscreate interactive`, el cual muestra un asistente en modo texto que ofrece una serie de preguntas interactivas esenciales (como el nombre de la instancia a crear, el puerto de escucha, si queremos activar TLS, etc) y, a partir de la respuesta dada en ellas, genera automáticamente el fichero "dse.ldif" adecuado. No obstante, deberemos acabar editando el archivo "dse.ldif" a mano para poder adaptarlo más específicamente a nuestras circunstancias (el asistente no pregunta todas las preguntas que necesitaríamos contestar), así que realmente no es de mucha ayuda.

!!! note "Nota"
    NOTA: Es posible crear otro backend (en principio del mismo tipo LDBM) separado del backend por defecto "userroot" para almacenar otro directorio diferente en la misma instancia. Eso se puede hacer así: 

        sudo dsconf -D "cn=admin" -W miservidor backend create –suffix dc=otrodominio,dc=local --be-name nombreBackend 

    Los cambios se verán reflejados, efectivamente, en el archivo "dse.ldif" d) Comprobar que, efectivamente, la instancia recién configurada haya sido arrancada correctamente mediante el comando sudo systemctl status dirsrv@miservidor (detrás de la arroba ha de ir el nombre de la instancia indicado en el asistente anterior...si no lo hemos modificado, por defecto este nombre se corresponderá con el nombre corto de la máquina). A partir de aquí, la instancia se podrá gestionar como cualquier otro demonio del sistema con systemctl start, systemctl stop, systemctl enable, systemctl disable,...

!!! note "Nota"
    NOTA: También se puede utilizar el comando `sudo dsctl miservidor status` para comprobar el estado de funcionamiento de la instancia indicada. El comando dsctl se puede emplear como sustituto de systemctl ya que tiene opciones para iniciar, parar, reiniciar, etc la instancia en cuestión. Una opción muy interesante (y peligrosa!) es la de eliminar completamente la instancia (y su/s directorio/s correspondiente/s), la cual es `sudo dsctl miservidor remove --do-it` 

!!! note "Nota"
    NOTA: At installation, Directory Server contains the following: a server front-end responsible for network communications, plug-ins for server functions, such as access control and replication, a basic directory tree containing server-related data (defined in "dse.ldif" file) and a database back-end plug-in responsible for managing the actual storage and retrieval of server data.

### Abrir puertos en el Firewall

    :::bash
    systemctl status firewalld
    systemctl enable firewalld
    systemctl start firewalld
    firewall-cmd --permanent --add-port={389/tcp,636/tcp}
    firewall-cmd --reload


##Administración básica del directorio:

Ya tenemos el servidor LDAP funcionando y escuchando en el puerto 389 TCP. Ahora deberíamos generar la estructura de entradas de nuestro directorio y rellenarlas de datos. 

!!!tip
    Comprueba desde el servidor, con el comando `ss -tln `, como aparece el socket escuchando en ese puerto

### Agregar información - Procedimiento genérico 
La forma más básica de añadir información a un directorio cualquiera es utilizar ficheros de texto cuyo contenido está escrito en el formato LDIF (LDAP Data Interchange Format).  El formato básico de una entrada es...: 

    :::text
    # comentario 
    dn: <nombre global único> 
        <atributo>: <valor> 
        <atributo>: <valor> 
        ... 

...donde los atributos indicados deben pertenecer a algún objeto perteneciente a algún "schema" previamente reconocido por el servidor para que sean interpretados correctamente (por suerte, todos los objetos que utilizaremos en este documento están definidos en "schemas" que ya vienen incluidos de serie en cualquier software de tipo servidor LDAP actual).

!!!note "Nota"
    En el caso de utilizar, por ejemplo, el servidor 389DS, los objetos que emplearemos a lo largo de este documento están definidos en el fichero `/usr/share/dirsrv/schema/00core.ldif` (el de tipo "organizationalUnit") y `/usr/share/dirsrv/schema/10rfc2307.ldif` (los de tipo "posixGroup", "posixAccount" y "shadowAccount"), etc Un objeto que también podríamos haber utilizado (pero no lo hemos hecho) es el objeto "hostObject" (definido en `/usr/share/dirsrv/schema/60nss-ldap.ldif`), cuyo atributo más importante es "host" (el valor del cual puede ser una IP o un nombre DNS) y que permitiría alojar en el directorio información sobre las máquinas que formarían un dominio (y, eventualmente, aplicarles reglas de acceso, etc) 


Entre dos entradas consecutivas escritas en un archivo LDIF debe existir siempre una línea en blanco. Por otro lado, si una línea es demasiado larga, podemos repartir su contenido entre varias, siempre que las líneas de continuación comiencen con un carácter de tabulación o un espacio en blanco. 

Una vez creados estos ficheros, para añadirlos al directorio (incluso con   el servidor en marcha) podemos utilizar el comando `ldapadd` (disponible al instalar el paquete llamado “ldap-utils” -en Ubuntu-, o"openldap-clients" -en Fedora- aunque en el caso de haber instalado el paquete "389-ds-base" ya se habrá instalado automáticamente como dependencia). La mayoría de veces necesitaremos indicar los siguientes parámetros: 

-  **-H ldap://nomDnsServidor:nºpuerto**: Indica el servidor LDAP (y,  opcionalmente, el número de puerto) contra el cual se van a ejecutar. Si el servidor LDAP estuviera funcionando en la misma  máquina   donde   se   ejecuta el comando `ldapadd`  (o cualquier otro de su familia:`ldapsearch`, `ldapmodify`, etc), normalmente este parámetro se podrá omitir. Si el servidor LDAP funciona sobre TLS (es decir, es un servidor LDAP seguro), la URL a indicar deberá ser 
  
        -H ldaps://nomDnsServidor:nºpuerto

    !!!note "Nota"
        NOTA:  Si el comando cliente (cualquiera de los que estudiaremos:  `ldapadd`, `ldapsearch`, `ldapmodify`, etc) se  ejecuta en la misma máquina donde está funcionando el servidor, en vez de conectar con éste mediante TCP (que es lo que pasa cuando se usa la url del tipo  ldap://...) automáticamente utiliza sockets internos que emplean el  mecanismo IPC, que es un sistema de intercomunicación entre procesos locales más óptimo para estos casos.  Aunque ya hemos dicho que no sería necesario, si se quisiera especificar la url, en este caso entonces se debería escribir así: `ldapi://%2fruta%2fcarpeta%2ffichero.socket` (notar que el protocolo es "ldapi" y no "ldap" y que las "/" se sustituyen por "%2f").
    
    !!!note "Nota"
        En el caso de contactar con un servidor LDAPS (es decir, funcionando sobre TLS), dicho servidor puede o bien ofrecer un certificado autofirmado o bien un certificado firmado por una determinada CA (Autoridad de  Certificación). En el primer caso, para que los clientes admitan ese servidor como seguro se ha establecer previamente la variable de entorno `LDAPTLS_REQCERT` al valor "never" (simplemente precediendo el comando en cuestión con la expresión `LDAPTLS_REQCERT=never` ya sería suficiente). En el segundo caso, se ha de establecer previamente la variable de entorno `LDAPTLS_CACERT` indicando la ruta del certificado de la CA (simplemente precediendo el comando en cuestión con la expresión `LDAPTLS_CACERT=/etc/dirsrv/slapd-miservidor/ca.crt`, por ejemplo, ya sería suficiente). Para que estas variables sean permanentes, se pueden indicar dentro del archivo `/etc/openldap/ldap.conf`

- **-D cn=admin**: Indica el "common name" de la cuenta de usuario (guardada en el propio servidor) con la que nos autenticaremos en el servidor LDAP para realizar la modificación del directorio; esta cuenta  ha  de  tener   privilegio   para  ello,   así   que   usaremos  la   cuenta   "admin"   que  creamos  en   la  instalación del servidor.
- **-W**  :   Solicita   interactivamente   la   contraseña   de   la   cuenta   anterior.   Otra   opción   sería   indicar   la  contraseña como un parámetro más, así : 

    -w contraseña (notar que en este caso la "w" es minúscula).

-  **-f fichero.ldif** : Indica el fichero cuyo contenido se desea agregar


### Ejercicios Agregar Datos
1.- a) Crea un fichero llamado `base.ldif` con el contenido mostrado a continuación y seguidamente agrégalo al directorio con el comando: `ldapadd -D cn=admin -W -f base.ldif` . Con esto habrás generado dos entradas de tipo “unidad organizativas” que servirán para contener (a modo de “carpetas”) los usuarios y grupos que generaremos a continuación.

    dn: ou=usuarios,dc=midominio,dc=local 
    objectClass: organizationalUnit 
    ou: usuarios 

    dn: ou=grupos,dc=midominio,dc=local 
    objectClass: organizationalUnit 
    ou: grupos 

1.-b) Crea un fichero llamado `grupos.ldif` con el siguiente contenido y seguidamente agrégalo al directorio con un comando similar al del apartado anterior:
    
    dn: cn=grupoldap,ou=grupos,dc=midominio,dc=local 
    objectClass: posixGroup 
    cn: grupoldap 
    gidNumber: 10000

1.-c) Crea un fichero llamado `usuarios.ldif` con el siguiente contenido y seguidamente agrégalo al directorio con un comando similar al del apartado anterior:

```text
dn: uid=usu1ldap,ou=usuarios,dc=midominio,dc=local
objectClass: top
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: usu1ldap
sn: Lopez
givenName: Juan
cn: Juan Lopez
displayName: Juan Lopez
uidNumber: 3001
gidNumber: 10000
userPassword: XXX
gecos: Es muy tonto
loginShell: /bin/bash
homeDirectory: /home/jlopez
shadowExpire: -1
shadowFlag: 0
shadowWarning: 7
shadowMin: 8
shadowMax: 999999
shadowLastChange: 10877
mail: juan.lopez@gmail.com
postalCode: 29000

dn: uid=usu2ldap,ou=usuarios,dc=midominio,dc=local
objectClass: top
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: usu2ldap
sn: Perez
givenName: Perico
cn: Pedro Perez
displayName: Pedro Perez
uidNumber: 3002
gidNumber: 10001
userPassword: XXX
gecos: Es un crack
loginShell: /bin/bash
homeDirectory: /home/pperez
shadowExpire: -1
shadowFlag: 0
shadowWarning: 7
shadowMin: 8
shadowMax: 999999
shadowLastChange: 10877
mail: pedrito@yahoo.es
postalCode: 29001

```

!!!note "Nota"
    Tal como se puede ver, cada objeto “usuario” está formado a partir de la unión de diferentes tipos predefinidos de objeto   (posixAccount,   shadowAccount,   inetOgPerson),   donde   cada   uno   aporta   un   determinado   conjunto   de   atributos:  posixAccount incluye la información que encontraríamos en el archivo "/etc/passwd" clásico, shadowAccount incluye la información que encontraríamos en el archivo "/etc/shadow" clásico y inetOrgPerson incluye información extra del usuario dentro de la organización (como el correo, cód. Postal...).

!!!note "Nota"
    Hay   que   tener  muy   en   cuenta  que   al   añadir   nuevos   usuarios   los   valores   de   los   atributos   uidNumber   y  homeDirectory   (además   de   userPassword)   deben   ser   diferentes   para   cada   usuario.   Lo   mismo   ocurre   con   el   atributo  gidNumber para los grupos. Además, los valores de uidNumber y gidNumber no deben coincidir con el uid y gid de ningúnusuario y grupo local de los clientes.

!!!note "Nota"
    El valor del atributo userPassword está protegido por ACLs predefinidas del servidor para que tan solo el usuario administrador - o el propietario del objeto que contenga dicho atributo- pueda consultar su valor (hasheado). Internamente, los valores de todos atributos se almacenan en el backend seleccionado pero en el caso del atributo userPassword este  almacenamiento se realiza del hash de la contraseña según el algoritmo predefinido que el servidor tenga configurado. Así pues, un intruso que tuviera acceso directo al backend no obtendría (de entrada) las contraseñas porque las tendría que  "crackear". Este aspecto es independiente del hecho de que las conexiones entre cliente y servidor deberían siempre estar encriptadas mediante TLS para evitar el robo de la contraseña en tránsito.
    
    No obstante, alguien podría objetar que escribir la contraseña de los usuarios tal cual en un archivo ldif es un gran riesgo deseguridad. En realidad, así es como se recomienda que se escriba este valor para dejar al servidor LDAP realizar el hash de la forma que internamente requiera con las comprobaciones pertinentes. De todas formas, si se desea, es posible escribir el valor del atributo userPassword de forma que esté "hasheado". Para ello primero hay que utilizar alguna utilidad que nos genere el hash necesario; en el caso de usar 389DS disponemos del comando pwdhash , el cual, mediante su parámetro -s permite especificar el algoritmo hash deseado. Por ejemplo, para obtener el hash SHA-512 salteado (el mismo algoritmo que   se   utiliza   actualmente   para   guardar   las   contraseñas   hasheadas   en   el   archivo   "/etc/shadow"   de   la   mayoría   de  distribuciones Linux) de la contraseña "hola" deberíamos ejecutarpwdhash -s SSHA512 hola El valor obtenido debería serasignado tal cual al campo userPassword; la parte entre llaves indica al servidor LDAP que dicho valor será un hash de ese tipo y que, por tanto, no deberá hashearlo él sino almacenarlo directamente

### Buscar información - ldapsearch
Para comprobar si el contenido anterior se ha añadido correctamente, podemos usar el comando `ldapsearch` (también del paquete “ldap-utils”), el cual permite hacer una búsqueda en el directorio. La mayoría de veces necesitaremos indicar, además de los parámetros `-H ldap://nomDnsServidor:nopuerto`, `-D
cn=admin` y `-W/-w contraseña` ya conocidos, otros como los siguientes:

-  **-LLL** : Indica a ldapsearch que muestre la respuesta en modo "no verboso" (más fácil de leer)

-  **d 1** : d 1, d 2, ..... establece el **nivel de debug** y muestra errores detallados en el resultado del comando.
   
-  **-b "dc=midominio,dc=local"** : Indica el DN "base" a partir del cual se empezará la búsqueda por las entradas inferiores del árbol. El ejemplo anterior buscaría a partir de la entrada raíz "para abajo" por todas las subentradas. Pero no es necesario que la entrada raíz sea el DN "base": si, por ejemplo, escribiéramos `-b "ou=grupos,dc=midominio,dc=local"` entonces solo se buscaría a partir de la organizationalUnit "grupos" "para abajo" por las subentradas que contuviera.

    !!!note "Nota"
        NOTA: En el servidor 389DS, l'entrada "cn=config" pot fer-se servir com a DN base per obtenir tota la configuració del propi servidor

-  **-s {base | one | sub }** : El comportamiento descrito en el párrafo anterior de buscar recursivamente todas las entradas por debajo de una entrada "base" dada (incluyendo ésta) es el comportamiento por defecto, que equivaldría a indicar el parámetro -s sub Pero otros valores de este parámetro modifican el "scope" de la búsqueda; por ejemplo, 
    -   -s base solamente muestra información de la entrada marcada como "base" y nada más (es decir, no recorre ninguna rama del árbol)
    -   -s one solamente muestra información de las entradas directamente colgando de la entrada "base" pero nada más (es decir, sólo muestra las entradas "hijas": ni muestra entradas "nietas" ni la propia entrada "base")

-  **"(atributo=valor)" "(atributo=valor)"**... : Filtro que permite "quedarse", de todas las entradas recorridas, solo con las que contienen el atributo indicado con el valor indicado. Existen otros filtros más sofisticados que se pueden estudiar en el cuadro inferior. Si aparece este parámetro, ha de ir escrito después de cualquier otro parámetro de los anteriores. Si no aparece, todas las entradas recorridas serán "válidas" para mostrarse.

    !!!note "Nota"
        * is a special value representing “any possible value”. It can be used to build a "presence" filter that requests all objects where the attribute is present and has a valid value, but we do not care what the value is. For instance, by default, ldapsearch provides the filter "(objectClass=*)"; because all objects must have an objectClass, this filter is the equivalent to saying “all valid objects”.

-  atributo atributo ... : De la información encontrada en las entradas recorridas (y ya filtradas, si fuera el caso), se muestra solo aquellos atributos indicados. Si aparece este parámetro, ha de ir escrito
después del filtro (si hubiera). Si no aparece -o se escribe "*"-, se mostrarán todos los atributos pertenecientes a las entradas recorridas (y ya filtradas si fuera el caso); en el caso de escribir "+" se mostrarán los metaatributos de la entradas recorridas (como la fecha de creación de la entrada, el usuario que la creó, etc).

    !!!note "Nota"
        To show what basedns are available, you can query the special ‘’ or blank rootDSE (Directory Server Entry) using "namingContexts" as the attribute to look up, like this:
            
            ldapsearch -D cn=admin -W -LLL -b "" -s base namingContexts




2.- Ejecuta el comando `ldapsearch -D cn=admin -W -LLL -b "dc=midominio,dc=local" uid=usu1ldap sn givenName` Con este comando de ejemplo estaremos buscando un usuario con `uid=usu1ldap` y pediremos
que nos muestre solo el contenido de los atributos sn y givenName. Comprueba que efectivamente sea así:

!!!note "Nota"
    Es posible realizar consultas anónimas (es decir, sin necesidad de autenticarse) pero para ello sería necesario configurar el servidor 389DS convenientemente (ver para más información) y sustituir los parámetros -D y -W de ldapsearch por -x

*A filter can request objects whose attribute values are greater/less than a value by "(uid>=test0005)" or "(uid<=test0005)".If used with letters, it compares alphabetically.

*A filter can request a partial match of an attribute value on the object by using the ‘*’ operator (multiple times if necessary): "(uid=*005)" or "(uid=*st000*)". Note you should always have at least 3 characters in your substring filter, else indexes may not operate efficently.

*Filters can be nested with AND (&) or OR (|) conditions. Condition applies to all filters that follow within the same level of brackets, that is: (condition (attribute=value)(attribute=value)).

- AND requires that for an object to match, all filter elements must match; this is the “intersection” operation and is written like this: "(&(uid=test0006)(uid=guest0006))"

- OR filters will return the aggregate of all filters; this is the union operation so provided an object satisfies one condition of the OR, it will be part of the returned set; it's written like this: 

        (|(uid=test0006)(uid=guest0007))

*A NOT filter acts to invert the result of the inner set. For example: "(!(uid=test0010))" Note you can’t list multiple parameters in a "not" condition: to combine NOT's you need to use this in conjunctionwith AND and OR.

!!!note "Nota"
    NOTA: *You can nest AND, OR and NOT filters to produce more complex directed queries. For instance this query:
        `(&(objectClass=person)(objectClass=posixAccount)(|(uid=test000*))(!(uid=test0001)))` 
        would be equivalent to...:
            
            (&
            (objectClass=person)
            (objectClass=posixAccount)
            (|
            (uid=test000*)
                )
            (!(uid=test0001))
            )

    ...and it expresses "All person whose name starts with test000* and not test0001".


Another example would be this: 

    (|(& (...K1...) (...K2...))(& (...K3...) (...K4...)))

which means 
    
    (K1 AND K2) OR (K3 AND K4)

###Borrar y modificar información ldapdelete y ldapmodify
Otros comandos importantes del paquete “ldap-util” son ldapdelete y ldapmodify. Un ejemplo del primero podría ser: 
    
    ldapdelete -D cn=admin -W "uid=usu2ldap,ou=usuarios,dc=midominio,dc=local"

donde se ha indicado el DN del elemento que se desea eliminar. 

El segundo tiene tres formas de modificar una entrada: cambiando el valor de un atributo , añadiendo un nuevo atributo o eliminando un atributo
existente:

1.  -Para cambiar, por ejemplo, el atributo uidNumber de un usuario, podríamos ejecutar el comando 
      
        ldapmodify -D cn=admin -W -f fichero.cambios 

    donde `fichero.cambios` debería tener un contenido como el siguiente (donde se especifica qué entradas se quieren modificar y de qué manera):

        dn:uid=usu2ldap,ou=usuarios,dc=midominio,dc=local
        changetype:modify
        replace:uidNumber
        uidNumber:3002

    !!!note "Nota"
        NOTA: La información anterior la podríamos haber introducido directamente desde la entrada estándar si no hubiéramos especificado el parámetro -f.

2.  -Para añadir un atributo nuevo (en este caso llamado jpegPhoto) deberíamos ejecutar el mismo comando ldapmodify anterior pero ahora `fichero.cambios` debería tener un contenido como este:

        dn:uid=usu2ldap,ou=usuarios,dc=midominio,dc=local
        changetype: modify
        add:jpegPhoto
        jpegPhoto:file:///tmp/foto.png

3.  -Para eliminar un atributo (en este caso llamado jpegPhoto) deberíamos ejecutar el mismo comando ldapmodify anterior pero ahora "fichero.cambios" debería tener un contenido como este:

        dn:uid=usu2ldap,ou=usuarios,dc=midominio,dc=local
        changetype: modify
        delete:jpegPhoto

!!!note "Nota"
    ya que la configuración del servidor 389DS es troba accessible en forma directori, la comanda ldapmodify es podria utilitzar per modificar aquesta configuració "en calent". Per exemple, sabent que les directives "nsslapd-ldapilisten" i "nsslapd-ldapifilepath" activen el mecanisme LDAPI i especifiquen la ruta del socket adient, respectivament, per activar aquesta característica (que ja ve de sèrie activada, però és només un exemple), podríem fer com sempre: 

            ldapmodify -D cn=admin -W -f fichero.cambios 

    pero ara el contingut del fitxer "fichero.cambios" seria:

            dn: cn=config
            changetype: modify
            replace: nsslapd-ldapilisten
            nsslapd-ldapilisten: on
            -
            add: nsslapd-ldapifilepath
            nsslapd-ldapifilepath: /var/run/slapd-exemple.socket

!!!note "Nota"
    NOTA: En realitat, per afegir entrades i per eliminar entrades no caldria fer servir les comandes ldapadd i ldapdelete respectivament, ja que amb ldapmodify ja n'hi hauria prou. En el cas de voler afegir una entrada el fitxer "fichero.cambios" hauria de tenir un contingut semblant al següent...:

            dn: <dn to add>
            changetype: add
            objectclass: ...
            attribute1: ...
            attribute2: ...

    ...i en el cas de voler eliminar una entrada, el seu contingut hauria de ser semblant a aquest:
            
            dn: <dn to delete>
            changetype: delete


3.-a) Modifica el atributo “gecos” del usuario Juan López para que muestre la descripción: “Ronca”.
Comprueba mediante ldapsearch que el cambio lo has realizado correctamente

b) Añade el atributo “jpegPhoto” del usuario Juan López indicando la ruta (ficticia) de su foto identificativa.
Comprueba mediante ldapsearch que el cambio lo has realizado correctamente

c) Elimina el atributo “jpegPhoto” anterior.Comprueba mediante ldapsearch que el cambio lo has realizado
correctamente

##ACIs
By default, the directory server denies access to everything. The administrator must allow certain types of access to certain resources for users to be able to use the directory server. The operational attribute
aci is used for access control. This attribute can be applied to any entry in the directory tree, and has subtree scope: it applies to the entry that contains it and any children and descendants of that entry.

An ACI consists of 3 parts: a target, a subject, and the type of access (permission):

*  The target represents the entry or resource is being protected. The target specification should be a DN (written with the syntax "ldap:///DN"), but can be stretched by specifying one or more atributes to restrict its application, or even a LDAP filter. Writing a target it's optional: by default it applies to
all entries in subtree scope of the entry which ACI is defined (that's is which contains the aciattribute).

*  The subject represents the entity which is granted (or denied) access to the target. The subject may be userdn="ldap:///DN" or groupdn="ldap:///DN" (where DN can be any DN of a user or a group, respectively). It also can be some of these values: userdn="ldap:///self" (to specify the user who has done the query), userdn="ldap:///anyone" (to specify anonymous binds), or
userdn="ldap:///all" (to specify any authenticated user). Modifiers can be used to allow or deny access based on the client IP address or hostname, access time, or connection type (encrypted or not). You can also use attributes to specify a subject with userattr="attrname" syntax.

*  The permission is any combination of the following keywords:
    * **read** Indicates whether directory data may be read. Indicates whether directory data may be changed or created. This permission also allows write directory data to be deleted but not the entry itself: to delete an entire entry, the user must have delete permissions.
    * **search** Indicates whether the directory data can be searched. This differs from the read permission in that read allows directory data to be viewed if it is returned as part of a search operation. For example, if searching for common names is allowed as well as read permission for a person's room number, then the room number can be returned as part of the common namesearch, but the room number itself cannot be used as the subject of a search. Use this combination to prevent people from searching the directory to see who sits in a particular room.
    * **add** Indicates whether child entries beneath the targeted entry can be created.
    * **delete** Indicates whether targeted entry can be deleted.
    * **all** Means all types of above accesses

    The permission is modified by using allow or deny If there are conflicts between what is allowed and what is denied, the deny wins. Better explained: when a user attempts any kind of access to a directory entry, Directory Server applies the precedence rule. This rule states that when two conflicting permissions exist, the permission that denies access always takes precedence over the permission that grants access. For example, if write permission is denied at the directory's root level, and that permission is applied to everyone accessing the directory, then no user can write to the directory regardless of any other permissions that may allow write access. To allow a specific user write permissions to the directory, the scope of the original deny-for-write has to be set so that it does not include that user. Then, there must be additional allow-for-write permission for the user in question.

    The aci attribute has the following syntax (version 3.0 and acl "name" values are mandatory and, as it can be seen, several targets can be specified as well as several allow(permission)(subject)... values):

        aci: (target="ldap:///DN)(target=...)(version 3.0; acl "name"; allow(per,miss,ion)(userdn="ldap:///subject"); allow...;)

    !!!note "Nota"
        NOTA: Some interesting modifiers to add in a ACI to restrict targeted entries are "targetattr" and "targetfilter" keywords, (which must be specified after these targeted entries). Another interesting keyword is "targetscope"


    For instance, in the following example, the ACI states that "bjensen" has rights to modify all attributes in her own directory entry: 

            aci: (target="ldap:///uid=bjensen,dc=example,dc=com")(targetattr="*")(targetscope="subtree")(version 3.0; acl "example"; allow (write)(userdn="ldap:///self");)

Access control rules can be placed on any entry in the directory although administrators often place access control rules on entries with the object classes "domainComponent", "organizationalUnit", "inetOrgPerson", or "group". You can add/replace/delete an aci attribute like any other using LDIF files and
ldapmodify command. For instance, this content would add the permission of anonymous searches/reads to all the directory's content:

    dn:dc=midominio,dc=local
    changetype: modify
    add:aci
    aci: (targetattr!="userPassword")(version 3.0; acl "xxx"; allow(read,search)(userdn="ldap:///anyone");)

The aci attribute is a multi-valued operational attribute that can be read and modified by directory users. Therefore, the ACI attribute itself should be protected by ACIs. Administration users are usually given full access to the aci attribute doing `ldapsearch -D cn=admin -W -b entryDN -s base "(objectclass=*)" aci`

## Login LDAP desde cliente con SSSD
### Introducción
En Linux se puede utilizar el demonio SSSD para autenticar al usuario contra servidores LDAP remotos (Combinados con servidores Kerberos o no) además de identificarlos. Mediante SSSD todo el proceso de autenticación / identificación del usuario se produce en el cliente de una forma homogénea y coherente, independientemente de la distribución Linux allí instalada.

!!!note "Nota"
    Además de autenticarse contra servidores LDAP "pelados" o combinados con Kerberos, el demonio SSSD también permite autenticar usuarios contra sistemas integrales empresariales como FreeIPA o Active Directory (los cuales internamente se basan en LDAP / Kerberos). En cambio, no puede trabajar (todavía) con SGBDs o servidores RADIUS como fuente de autenticación / identificación

Una gran ventaja de utilizar SSSD en vez de los módulos PAM / NSS "standalone"
individualmente es que este demonio guarda una caché (en la carpeta `/var/lib/sss/db`) que permite el acceso "Offline" a / los sistema/s cliente/s (sin tener ninguna cuenta local diferente) en el caso de que el servidor LDAP / Kerberos remoto no esté disponible en ese momento o, en caso de que sí, disminuir su carga.

!!!note "Nota"
    NOTA: El demonio SSSD también ofrece una interfaz D-Bus para poder interactuar con el sistema mediante este método y así obtener, por ejemplo, información extra sobre el usuario (tal como veremos).

El demonio SSSD proporciona sus propios módulos PAM y NSS para conectar con servidores LDAP / Kerberos y LDAP, respectivamente, los cuales son diferentes de los módulos "standalone" pam_ldap / pam_krb5 y nss_ldap ya conocidos. Esto es porque SSSD ofrece funcionalidades extra como un framework conjunto y librerías homogéneas, un mecanismo de caché de credenciales -similar al que ofrecía el demonio ncsd, ya obsoleto-, una interfaz D-Bus, etc. Para que los programas de inicio de sesión (login, gdm, su, sudo, ssh, etc) utilicen los módulos PAM / NSS propios de SSSD deberemos realizar un conjunto de configuraciones al sistema que explicaremos a continuación.

!!!note "Nota"
    NOTA: En Ubuntu hay que instalar el paquete "sssd" (es decir, el demonio SSSD no viene preinstal.lat "de fábrica"). Afortunadamente, al instalar este paquete ya se instalarán automáticamente como dependencia el resto de paquetes que podamos necesitar, como los conectores con los diferentes providers: "sssd-ldap", "sssd-krb5", "sssd-ipa", etc. En Fedora todos estos paquetes ya vienen instalados "de fábrica".

###Configuración de SSSD:
SSSD lee los archivos de configuración en este orden: primero lee el archivo primario `/etc/sssd/sssd.conf` y luego, otros archivos `* .conf` en `/etc/sssd/conf.d` (en orden alfabético). Si aparece el mismo parámetro en múltiples archivos de configuración, SSSD usa el último parámetro de lectura. Esto le permite usar el valor predeterminado `/etc/sssd/sssd.conf` en todos los clientes y aagregar configuraciones adicionales en otros archivos de configuración para extender la funcionalidad individualmente por cliente. 

!!!warning "Atención" 
    Todos estos archivos deben ser propiedad de `root:root` y
    tener permisos `600` de lo contrario el servicio sssd no se iniciará.

Los proveedores de autenticación e identidad se configuran como "dominios" en el archivo de configuración SSSD.

Puede configurar varios dominios para SSSD pero al menos un dominio debe estar configurado, de lo contrario, SSSD no arrancará. Un solo dominio se puede usar como:

*  Un proveedor de autenticación (para solicitudes de autenticación)
*  Un proveedor de identidad (para información del usuario)
*  Un proveedor de control de acceso (para solicitudes de autorización). No los estudiaremos aquí.
*  Una combinación de estos proveedores (si todas las operaciones correspondientes se realizan dentro de un solo servidor)

!!!note "Nota"
    También hay lo que se llama un proveedor "proxy". Este proveedor funciona como un intermediario de retransmisión entre SSSD y recursos que SSSD de otra forma no podrían usar. Cuando se usa un proveedor proxy, SSSD se conecta al servicio proxy, y el proxy carga las bibliotecas especificadas. Con un proveedor de proxy, puede configurar SSSD para utilizar métodos de autenticación alternativos, como un escáner de huellas digitales, entre otras cosas. 

#### Sección [sssd]
En el archivo "sssd.conf" debe haber al menos una sección general [sssd] y una sección para cada dominio. Debajo de la sección [sssd] debemos tener en cuenta esta línea (más información en man sssd.conf):

    domains =

Especifica una lista separada por comas de dominios definidos en el orden que desee para ser consultado Por lo tanto, si un dominio no aparece en esta lista, no se consultará aunque esté definido en el archivo "sssd.conf"

#### Sección [domain/xxx]
Las secciones correspondientes a dominios definidos deben titularse así `[domain/xxx]` donde "xxx" puede ser cualquier cosa. Debajo de una sección de dominio debemos tener en cuenta estas líneas (más en man sssd.conf):

-  **Line "auth_provider =**": establece el proveedor de autenticación utilizado para el dominio. Los valores posibles son:
        -  "ldap", "krb5", "ipa", "ad" o "proxy", entre otros. Dependiendo del proveedor elegido, habrá sea ​​necesario escribir líneas más específicas (ver man sssd-ldap, man sssd-krb5, man sssd-ipa u man sssd-ad para más detalles).
-  -Line **"id_provider ="**: establece el proveedor de identidad utilizado para el dominio. Los valores posibles son: "ldap", "archivos", "ipa", "anuncio" o "proxy". Dependiendo del proveedor elegido, habrá que escribir líneas más específicas (vea man sssd-ldap, man sssd-files, man sssd-ipa o man sssd-ad para más detalles).
-  -Line **"access_provider ="**: establece el proveedor de acceso utilizado para el dominio, que se utiliza para evaluar qué usuarios tienen acceso al sistema. Incluso si un usuario se autentica con éxito, si no Si cumple con los criterios proporcionados por el proveedor de acceso, su acceso será denegado. Los valores posibles son:
"ldap", "krb5", "simple", "ipa", "ad", "proxy", "denegar" (siempre niega el acceso) o "permitir" (por defecto,siempre permite el acceso). Dependiendo del proveedor elegido, habrá que escribir más.
-  **líneas específicas** (vea man sssd-ldap, man sssd-krb5, man sssd-simple, man sssd-ipa o man sssd-ad para detalles).

!!!note "Nota"
    NOTA: El proveedor de acceso "simple" permite o niega el acceso basado en una lista de nombres de usuario o grupos. Permite restringir el acceso a máquinas específicas. Por ejemplo, en las computadoras portátiles de la compañía, puede usar el proveedor de acceso simple  para restringir el acceso solo a un usuario específico o un grupo específico. Otros usuarios o grupos no podrán iniciar sesión incluso si se autentican correctamente en el proveedor de autenticación configurado.

    ```
    [domain/nombre_dominio]
    ...
    access_provider = simple
    simple_allow_users = usuario1, usuario2
    #simple_allow_groups = group1
    ```

Si el proveedor de acceso que está utilizando es el "ldap", también puede especificar un filtro de control de acceso LDAP que el usuario debe coincidir para poder acceder al sistema.

    [domain/domain_name]
    ...
    access_provider = ldap
    ldap_access_filter = (memberOf=cn=allowedusers,ou=Groups,dc=example,dc=com)
    #ldap_access_order = filter, host, authorized_service

!!!note "Nota"
    NOTA: La directiva ldap_access_order puede tener estos valores (se pueden indicar por orden de aplicación):
        
        *"filter" : Se usa el filtro indicado en ldap_access_filter como criterio. Valor per defecto
        *"host" : Se usa el atributo "host" en el directorio como criterio
        *"authorized_service" : Se usa el valor de "authorizedService" en el directorio como criterio
        *"expire" : Se usa el valor de la directiva ldap_account_expire_policy como criterio

-  **-Line "chpass_provider =**": establece el proveedor que debe manejar las operaciones de cambio de contraseña para el dominio. Los valores posibles son: "ldap", "krb5", "ipa", "ad", "proxy" o "none" (esto explícitamente deshabilita la capacidad de cambiar las contraseñas). Si no se especifica esta línea, entonces se usa por defecto el valor especificado en la línea "id_provider". Ver man sssd-sudo para detalles 

    !!!note "Nota"  
        Nota SSSD no almacena en caché las credenciales de usuario de forma predeterminada. Entonces, al procesar solicitudes de autenticación,de manera predeterminada, SSSD siempre contacta al proveedor de identidad; si el proveedor no está disponible, la autenticación de usuario falla Para garantizar que las credenciales se almacenen localmente después de autenticar con éxito a los usuarios para que puedan mantener autenticación incluso cuando el proveedor de identidad no está disponible, debe habilitar el almacenamiento en caché de credenciales local agregando la línea cache_credentials = true debajo de la sección de dominio correspondiente. Por defecto, la credencial la memoria caché nunca caduca: si desea que sssd elimine las credenciales almacenadas en caché, account_cache_expiration = line hacer que caduquen después del número de días especificado.

    !!!note "Nota"  
        Cuando un usuario intenta una operación de sudo, ya sabemos que SSSD contacta al proveedor de identidad / sudo definido en el dominio para obtener la información requerida sobre la configuración actual de sudo. Si la línea cache_credentials se establece en true,también almacenará esa información de sudo en una memoria caché, para que los usuarios puedan realizar operaciones de sudo incluso cuando LDAP / IPA / AD El servidor está fuera de línea.
 
####Secciones opcionales [pam] y / o [nss]
Las secciones opcionales [pam] y / o [nss] también pueden aparecer en el archivo "sssd.conf". Podrían ser utilizadas para configurar algunos aspectos del comportamiento de los módulos PAM o NSS de SSSD, respectivamente. Por ejemplo, si se quiere configurar un límite de tiempo (en días) para cuánto tiempo SSSD permite la autenticación sin conexión si el proveedor de  identificación no está disponible, puede usar la línea 
`offline_credentials_expiration =` debajo de la sección `[pam]` para especificar ese límite de tiempo. Otras líneas interesantes para especificar debajo de la sección `[pam]` son `offline_failed_login_attempts =`, `offline_failed_login_delay =` o `reconnection_retries`, entre otros.

Igualmente, debajo de la sección `[nss]` algunas líneas interesantes que merecen atención son `filter_groups =` y `filter_users =` (que excluye a ciertos usuarios, por defecto, solo "root") de ser extraídos del backend NSS
Esto es particularmente útil para las cuentas del sistema .; esta opción también se puede establecer por dominio o incluir nombres totalmente calificados para filtrar solo usuarios del dominio en particular), `entry_cache_timeout =` (que especifica cuántos segundos, por defecto 5400- debe considerar sssd entradas válidas antes de preguntar al NSS backend otra vez),
        
    "entry_cache_nowait_percentage =",
    "override_homedir =",
    "override_shell =",
    "allowed_shells =", etc.


####Ejemplo 1 (un servidor LDAP como proveedor de autenticación e identidad)
Un fichero "sssd.conf" podría ser algo así:

    [sssd]
    domains=pepito
    [domain/pepito]
    auth_provider=ldap
    id_provider=ldap
    ldap_uri=ldaps://ldapserver.example.com
    ldap_search_base=dc=example,dc=com

!!!note "Nota"
    SSSD always uses an encrypted channel for authentication, which ensures that passwords are never sent over the network unencrypted but forces the LDAP server to run over TLS. If this LDAP server used a self-signed certificate, you must add the line `ldap_tls_reqcert=allow` in the `sssd.conf` file so that client doesn't reject it. If this LDAP used a ca-signed certificate instead, you should add the line `ldap_tls_cacert = /etc/pki/tls/certs/ca-bundle.crt` instead (pointing to the right CA's bundle file in each case). Anyway, if you wanted identity lookups (such as commands based on the id or getent utilities) were also encrypted (or if LDAP server only runs over TLS), you should add the "`ldap_id_use_start_tls =true` line.

!!!note "Nota"
    If LDAP server's configuration requires that queries to LDAP directory have to be authenticated, you should add the `ldap_default_bind_dn= cn=admin` and `ldap_default_authtok= 12345` lines to specify which user ("cn=admin" in this example) and password ("12345" in this example) should be used to do these queries, respectively.


####Example 2 (a KDC server as authentication provider and a LDAP server as identity provider)
A suitable sssd.conf file could be like this:
    [sssd]
    domains=pepito
    [domain/pepito]
    auth_provider=krb5
    krb5_server=kdc.example.com
    krb5_realm=EXAMPLE.COM
    id_provider=ldap
    ldap_uri= ...
    ldap_search_base= ...

!!!note "Nota"
    NOTA: If the Change Password service is not running on the KDC specified in "krb5_server" or "krb5_backup_server" lines, you can use the "krb5_passwd" line to specify the server where the service is running or a chpass_provider instead.

[IP fija]:/LPIC1/Networking/#establecer-una-configuracion-dinamica-de-forma-permanente

[autenticar/identificar]:/LPIC3/2-Autenticaci%C3%B3n-Autorizaci%C3%B3n/Autenticaci%C3%B3n_vs_Autorizaci%C3%B3n/#autenticacion-vs-autorizacion