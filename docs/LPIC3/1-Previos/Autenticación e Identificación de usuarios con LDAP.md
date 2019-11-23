# Autenticación/Identificación de usuarios con LDAP

## PAM (autenticación):

PAM (de "Pluggable Authentication Modules") es, tal como ya sabemos, un conjunto de librerías especializadas en el ámbito de la autenticación que permite a los programas que hagan uso de ellas (por ejemplo: ssh, su, sudo, login, gdm, etc) poder utilizar distintos métodos de autenticación a conveniencia de forma totalmente transparente para dichos programas. Es decir: PAM permite que, sin realizar modificaciones en el código de los programas, podamos utilizar métodos que vayan desde el uso típico de un nombre de usuario y una contraseña, hasta dispositivos que faciliten identificación biométrica (lectores de huellas, de voz, de imagen, etc.) simplemente indicándoselo en determinados ficheros de configuración.

## NSS (identificación):
PAM solo se encarga de la autenticación: es decir, de decidir si el usuario en cuestión "puede entrar" en el sistema o no según si determinadas condiciones resultan correctas o no (condiciones que dependerán del método utilizado pero que pueden ser, por ejemplo, -y sería el caso más habitual- una combinación de
nombre de usuario + contraseña). No obstante, para que el inicio de sesión de un usuario sea completo y dicho usuario sea reconocido como tal sin errores, el sistema debe conocer más datos de ese usuario. Por ejemplo, ha de saber a qué grupo/s pertenece ese usuario, o qué shell por defecto tiene, o cuál es la ruta de su carpeta personal, o la fecha de caducidad de su contraseña, etc. De obtener toda esta información complementaria del usuario recién autenticado se encarga otro conjunto de librerías llamado NSS (de "Name Service Switch", con ruta en /lib/libnss_* o /lib/x86_64-linux-gnu/libnss_*). En otras palabras: PAM se dedica a responder a la pregunta "¿Fulanito puede entrar?" y NSS se dedica a responder a la pregunta "¿Qué sabemos de Fulanito?"

Normalmente, NSS obtiene la información necesaria de los archivos `/etc/passwd`, `/etc/group` y `/etc/shadow` porque así está indicado en el archivo `/etc/nsswitch.conf` (en las líneas "passwd", "shadow" y " group ", respectivamente). Por lo tanto, si no cambiamos nada del subsistema NSS y sólo configuramos el módulo PAM para que la autenticación se produjera, por ejemplo, contra un servidor LDAP remoto, "nos habríamos quedado a medio camino" para que sólo en el caso de que el mismo nombre de usuario exista tanto dentro del servidor LDAP como dentro de los archivos /etc /passwd y / etc/shadow el inicio de sesión funcionaría ya que, como hemos dicho, se utilizaría el servidor LDAP para autenticar (vía PAM) y la información NSS estándar (vía ficheros "/etc /passwd" y familia) para completar la información sobre este usuario. Si lo que queremos es tener un sistema que incluya información NSS, independiente de la estándar (la cual, por qué no, podría estar almacenada igualmente en el mismo servidor LDAP), será necesario instalar un módulo NSS que añada a este subsistema la posibilidad de buscar este tipo de información en este otro origen diferente del estándar. Para decidir cuál es el origen escogido entre varios posibles, las aplicaciones que hacen uso de NSS consultan primero el archivo "/etc/nsswitch.conf" para saber si la información sobre los usuarios la han de obtener de los ficheros locales ( "/etc /passwd" y "/etc /shadow") o bien, mediante el uso de algún módulo NSS concreto previamente instalado, la han de obtener de alguna base de datos remota como podría ser un servidor LDAP (o, por qué no, complementar ambos orígenes para que si falla el predeterminado utilice el otro).

!!!NOTE "Nota"
    En realidad, el subsistema NSS es un mecanismo mucho más global que sirve para escoger otros orígenes de información que no tienen nada que ver con "características de usuarios". para conocer la correspondencia entre nombres de máquinas y su ip, las “aplicaciones NSS” consultarán /etc/nswitch.conf para saber si primero han de consultar en un servidor DNS o bien pueden obtener la información del fichero /etc/hosts, o bien pueden complementar ambos orígenes en un orden determinado. Així doncs, en general, el que permet el subsistema NSS es que las aplicaciones que hayan sido programadas haciendo uso de él puedan utilizar de forma coherente y común un conjunto de orígenes de datos conteniendo los nombres de distintos ítems, (como máquinas, redes, nombres de protocolos, usuarios, grupos, etc.) que dichas aplicaciones necesitan.

!!!NOTE "Nota"
    Una altra avantatge de què una aplicació faci servir NSS és que poden obtenir la informació que necessiten (nombres de usuarios y sus contraseñas, nombres de máquinas, de redes, de protocolos, etc) preguntando directamente a NSS (y éste utilizando la librería concreta adecuada según lo que se encuentre en /etc/nsswitch.conf) sin tener que conocer el lugar exacto donde está almacenada, (ya que para obtenerla ya se encarga NSS)

Un ejemplo de archivo "/etc/nswitch.conf" muy simple sería el siguiente:
    
    passwd: files
    group: files
    shadow: files
    hosts: files dns
    networks: files
    protocols: files
    services: files
    ethers: files

...donde principalmente se indica (mediante la línea passwd:...) que la base de datos de usuarios que se va a utilizar es el fichero local `/etc/passwd` (gracias al valor files), que la base de datos de grupos es el fichero
local `/etc/group` (mediante la línea group:...), que la de contraseñas es el fichero local `/etc/shadow` (mediante la línea shadow:...) y que la de nombres de máquinas será (gracias a la línea hosts:...) en primera instancia el fichero local `/etc/hosts` (ver `man hosts` para más información sobre este fichero, o también http://en.wikipedia.org/wiki/Hosts_%28file%29), y, si no se encuentra el nombre allí, entonces se procederá (ya que tras “files” está el valor “dns”) a realizar una búsqueda DNS en los servidores configurados en
`/etc/resolv.conf`

!!!NOTE "Nota"
    Las otras líneas del archivo `/etc/nsswitch.conf` no son tan utilizadas pero las comentamos aquí: la línea networks indica que los nombres de redes se buscarán en el fichero local `/etc/networks` (ver `man networks` para más información sobre este fichero), la línea protocols indica que los nombres de los protocolos se buscarán en el fichero local `/etc/protocols` (ver `man protocols` para más información sobre este fichero), la línea services indica que los nombres de los servicios se buscarán en el fichero local `/etc/services` (ver `man services` para más información sobre este fichero) y la línea ethers indica que la correspondencia estática entre direcciones MAC e IPs se buscará en el fichero local `/etc/ethers` (ver `man ethers` para más información sobre este fichero).

##LDAP

LDAP (“Lightweight Directory Access Protocol”) es un protocolo de nivel de aplicación que permite acceder a un “servidor de directorio”. Por “directorio” se entiende un conjunto de datos organizados de una manera lógica y jerárquica en forma de elementos llamados “entradas”, los cuales poseen diversos atributos.

Cada entrada representa un objeto que puede ser abstracto o real (una persona, un mueble, una función en la estructura de una empresa, etc). La utilidad de un servidor de directorio radica en ofrecer dichos objetos a la red de una forma centralizada (y, opcionalmente, transparentemente distribuida). Se puede entender que un servidor de directorio pueda ser equivalente a un servidor de bases de datos, pero su sistema de almacenamiento es diferente y su manera de consultar y manipular la información contenida en él también.

Aunque no tiene por qué ser así siempre, el tipo de información que suele encontrarse en la mayoría de ocasiones en un servidor LDAP es típicamente aquella relacionada con la autenticación e identificación centralizada de usuarios (nombre, contraseña, uid, grupo, permisos, etc), o con la autenticación e identificación centralizada de máquinas (nombre, dirección MAC, dirección IP, etc). También puede contener información complementaria de usuarios (correo, teléfonos, dirección, etc) o configuraciones centralizadas
de aplicaciones y certificados, etc.

Para definir los atributos que tendrán las entradas almacenadas en un servidor LDAP podemos hacer uso de las llamadas “Reglas de Esquema”. Éstas son plantillas que especifican qué atributos formarán la entrada de forma obligatoria y cuáles de forma optativa (a modo de “esqueleto” de la entrada). La/s “Regla/s de Esquema” concreta/s utilizada/s por una entrada determinada (porque una entrada puede tener asociadas varias reglas, acumulándose entonces en la entrada todos los atributos presentes en cada una de ellas) se
indica/n mediante un atributo especial de la entrada llamado "objectClass"; el valor de este atributo representa una Regla elegida (si hay varias, cada una se especificará en un atributo "objectClass" diferente).

Lo más normal es asignar al atributo "objectClass" de una entrada el nombre de una Regla ya predefinida a escoger de entre un conjunto de Reglas estandarizadas que ofrece todos los servidores LDAP; también
podríamos crear nuestras propias Reglas de Esquema (o modificar alguna existente; para más información sobre cómo hacer ambas cosas consultar por ejemplo http://www.zytrax.com/books/ldap/ch3), pero no suele
ser necesario porque las Reglas predefinidas cubren la mayoría de casos prácticos y son oficiales.

!!!NOTE "Nota"
    NOTA: En el caso de carecer de atributo “uid”, el atributo que suele hacer de identificador de la entrada suele ser “cn”.

!!!NOTE "Nota"
    NOTA: Una Regla que TODOS las entradas de un árbol de directorio han de implementar (mediante su correspondiente atributo "objectClass"), independientemente del resto de Reglas que se deseen añadir en cada una de ellas, es una Regla llamada "top". Al implementar esta Regla en una entrada lo que se consigue es que esa entrada pueda disponer precisamente del atributo "objectClass" (es decir, el atributo "objectClass" está definido en la Regla "top", a modo de definición recursiva).

Las entradas se organizan en una estructura jerárquica en forma de árbol invertido. Tradicionalmente,la parte superior de esta estructura refleja la jerarquía de los dominios DNS (incluso regionales) de la organización, de manera que las entradas que representan a la compañía (como “pepsi.com”, “unicef.org” o “yahoo.es”) aparecen en el árbol por encima de otras entradas que representan unidades organizativas internas. Las primeras suelen identificarse por la presencia del atributo “dc” (domain component), y para
cada subdominio hay una (dc=”pepsi” y dc=”com” para “pepsi.com”, dc=”unicef” y dc=”org” para “unicef.org”, etc). Dentro de las últimas es donde se encuentra la información relativa a usuarios, máquinas, documentos o cualquier otra cosa que queramos.

Sea del tipo que sea (“domain component” o no) y represente lo que represente, toda entrada posee un único “Nombre Distinguido” -“Distinguised Name” (DN)-, que sirve para identificarla de manera unívoca. El DN, de hecho, se construye a partir del identificador de la entrada en sí misma (lo que se llama
“Nombre Relativo Distinguido” -”Relative Distinguished Name” (RDN)-, y que suele ser el valor de su atributo “uid” o bien “cn” -o “ou” en el caso de las unidades organizativas-) concatenado con los identificadores de las entradas de sus antecesores separados por comas. Por ejemplo: si el DN de una entrada
es “uid=pperez,ou=empleados,dc=nike,dc=es”, nos estaremos refiriendo a una entrada (cuyo RDN es “uid=pperez”) que contiene información sobre el empleado Pperez perteneciente a la sección española de Nike. Para conocer toda esa información, deberíamos observar el resto de atributos de esa entrada
(objetClass, cn, givenname, sn, o,mail ...).

!!!NOTE "Nota"
    Una explicación más pormenorizada sobre cómo se organiza la estructura en árbol de un directorio LDAP se encuentra en https://fy.blackhats.net.au/blog/html/pages/ldap_guide_part_1_foundations.html

LDAP tiene definidas las operaciones necesarias para interrogar y actualizar el directorio (adicionar y borrar una entrada, modificar una entrada existente, cambiar el nombre de una entrada, etc). No obstante, la
mayor parte del tiempo LDAP se utiliza para buscar información almacenada en el directorio: las operaciones de búsqueda permiten que en una porción del directorio se busquen entradas que cumplan con algún criterio especificado en el filtro de búsqueda.

Algunos servidores de directorio no tienen protección y permiten que cualquier persona consulte la información que contienen, pero LDAP provee un mecanismo para que los clientes se autentiquen, (o al menos confirmen su identidad) para garantizar un control de acceso y proteger así la información que el
servidor contiene.

Nosotros utilizaremos la infrastructura LDAP para poder loguearnos en un PC mediante un usuario y contraseña guardados en forma de entrada dentro de un servidor de directorio, obteniendo además información adicional sobre dicho usuario (ruta de su carpeta personal, shell preferido, grupo/s de usuarios al
que pertenece, etc) para poder asignarle los permisos adecuados. Es decir, usaremos el servidor LDAP como centro de autentificación e identificación de los usuarios de nuestra red.

##Implementaciones de servidores

Existen varios servidores LDAP libres. Uno de los más extendidos es OpenLDAP
(http://www.openldap.org) pero existen varios más:
- Apache DS (http://directory.apache.org/apacheds). Incluye servidor Kerberos integrado.
- 389 Directory Server (http://www.port389.org) . Servidor LDAP “nativo” de Fedora.
- OpenDJ (https://github.com/OpenIdentityPlatform/OpenDJ)

También hay que destacar la existencia de soluciones integradas formadas por un servidor LDAP más otros servidores que complementan la funcionalidad de dicho servidor LDAP, facilitando en gran medida la integración de todos estos servicios (muy habitualmente utilizados en conjunto) entre sí. Ejemplos
son:

- **[FreeIPA](http://www.freeipa.org)**  : Servidor LDAP 389 Directory Server + Servidor Kerberos (tipo MIT) + Servidor DNS propio + Servidor NTP propio + Autoridad Certificadora propia +Servidor HTTP propio (para gestionarlo todo vía web). Es la solución elegida por Fedora

- [**Samba4**](http://www.samba.org) : Servidor LDAP propio + Servidor Kerberos (tipo Heimdal) + Servidor DNS propio + Servidor NTP propio + Servidor de compartición de carpetas.

- [**Active Directory**](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-domain-services) : “Suite” de servidor LDAP + Kerberos + DNS + NTP (entre otros) desarrollada por Microsoft e integrada en las versiones “Server” de sus sistemas Windows para poder almacenar y gestionar de forma centralizada la información de sus dominios de administración (usuarios, equipos, configuraciones, permisos, etc).