##Administración básica del directorio:

Ya tenemos el servidor LDAP funcionando y escuchando en el puerto 389 TCP. Ahora deberíamos generar la estructura de entradas de nuestro directorio y rellenarlas de datos. 

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

2.- Ejecuta el comando ldapsearch -D cn=admin -W -LLL -b "dc=midominio,dc=local" uid=usu1ldap sn
givenName Con este comando de ejemplo estaremos buscando un usuario con uid=usu1ldap y pediremos
que nos muestre solo el contenido de los atributos sn y givenName. Comprueba que efectivamente sea así:
NOTA: Es posible realizar consultas anónimas (es decir, sin necesidad de autenticarse) pero para ello sería necesario
configurar el servidor 389DS convenientemente (ver para más información) y sustituir los parámetros -D y -W de
ldapsearch por -x
*A filter can request objects whose attribute values are greater/less than a value by "(uid>=test0005)" or "(uid<=test0005)".
If used with letters, it compares alphabetically.
*A filter can request a partial match of an attribute value on the object by using the ‘*’ operator (multiple times if necessary):
"(uid=*005)" or "(uid=*st000*)". Note you should always have at least 3 characters in your substring filter, else indexes
may not operate efficently.
*Filters can be nested with AND (&) or OR (|) conditions. Condition applies to all filters that follow within the same level of
brackets, that is: (condition (attribute=value)(attribute=value)).
- AND requires that for an object to match, all filter elements must match; this is the “intersection” operation and is
written like this: "(&(uid=test0006)(uid=guest0006))"
- OR filters will return the aggregate of all filters; this is the union operation so provided an object satisfies one
condition of the OR, it will be part of the returned set; it's written like this: "(|(uid=test0006)(uid=guest0007))"
*A NOT filter acts to invert the result of the inner set. For example: "(!(uid=test0010))" Note you can’t list multiple
parameters in a "not" condition: to combine NOT's you need to use this in conjunctionwith AND and OR.NOTA: *You can nest AND, OR and NOT filters to produce more complex directed queries. For instance this query:
"(&(objectClass=person)(objectClass=posixAccount)(|(uid=test000*))(!(uid=test0001)))" would be equivalent to...:
(&
(objectClass=person)
(objectClass=posixAccount)
(|
(uid=test000*)
)
(!(uid=test0001))
)
...and it expresses "All person whose name starts with test000* and not test0001".
Another example would be this: "(|(& (...K1...) (...K2...))(& (...K3...) (...K4...)))", which means "(K1 AND K2) OR (K3 AND K4)"