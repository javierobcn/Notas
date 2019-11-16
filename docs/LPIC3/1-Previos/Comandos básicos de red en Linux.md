# Comandos básicos de red en Linux
## Nomenclatura de tarjetas de red:
Las tarjetas de red en sistemas Linux se pueden llamar de las siguientes maneras:

- **lo**: Corresponde a la tarjeta "loopback". Recordemos que hemos dicho que esta tarjeta físicamente no existe (es un "invento" del sistema operativo) y suele tener siempre tiene la IP 127.0.0.1/8. Sirve para establecer una conexión con sí misma, de tal forma que podemos tener en la misma máquina un programa cliente que conecte a un programa servidor sin salir "fuera".
- **eno1, eno2**: Tarjetas Ethernet integradas en la placa base ( "on-board")
- **ens1, ens2**: Tarjetas Ethernet PCI ( "slot")
- **enp2s0, p3p1**: Tarjetas Ethernet que no se pueden localizar de otra forma debido a limitaciones de la BIOS
- **wlp2s0**:tarjetas WiFi

Dentro de las máquinas virtuales de VirtualBox las tarjetas de red cogen siempre un nombre concreto: la tarjeta correspondiente a la primera pestaña del cuadro de configuración de red se llamará "enp0s3" dentro del sistema virtualizado, la segunda "enp0s8", la tercera "enp0s9" y la cuarta "enp0s10".

## Ver la configuración actual
### Estado y configuración de las tarjetas detectadas
El comando `ip address show` (o bien `ip address show dev nomTarjeta` si sólo se quiere obtener la información de una tarjeta determinada) nos muestra:

- Las direcciones MAC de las tarjetas
- Su estado respectivo (UP, DOWN)
- Sus direcciones IP respectivas (y la máscara correspondiente)
- Otros datos (como si permite el envío "broadcast", si está en modo "promiscuo", etc).

> NOTA: El comando `ip address show` se puede escribir de forma más corta así: `ip a s`. Incluso, se puede dejar de escribir el verbo show (o s) porque es la acción por defecto (por lo tanto, se puede hacer `ip address` o `ip a` y sería lo mismo). También es útil el parámetro -c (así: `ip -c a s`) para ver los datos más relevantes en colores.

Para activar / desactivar una tarjeta: ip link set {up|down} dev nomTarjeta

### Puerta de enlace
El comando `ip route show` (o bien `ip route show dev nomTarjeta` o sus variantes `ip route`, `ip r s` o `ip r`) debe mostrar una línea que comenzará con la expresión **"default vía"** seguida de la dirección IP de la puerta de enlace establecida. 
Este comando puede mostrar más líneas, pero no nos interesarán mucho ... (quizás la más curiosa es una que sirve para indicar que no hay ninguna puerta de enlace para comunicarse con las máquinas que pertenezcan a la misma red a la que pertenece nuestra máquina).

### DNS
Para saber la dirección IP del servidor DNS configurado en nuestra máquina (o las IPs … si hay más de una se prueba conectar a la primera y si esta falla entonces se prueba la segunda, y así) se puede consultar el archivo `etc/resolv.conf` (concretamente, las líneas que comienzan por la palabra nameserver). Estos servidores serán los que todas las aplicaciones del sistema (desde el ping hasta el navegador) utilizarán para averiguar cuál es la IP del nombre que el usuario haya escrito.

El contenido de este archivo suele ser gestionado por diferentes programas (como puede ser el cliente **dhclient**, la aplicación **NetworkManager**, el servicio **networking**, el servicio **systemd-networkd/resolved**, etc) y es por ello que no se recomienda modificarlo manualmente ya que los cambios realizados a mano podrían «Machacar» sin avisar en cualquier momento por cualquiera de estos programas.

En este sentido, estos programas (**dhclient, NetworkManager, «networking», «systemd-networkd / resolved, etc**) guardan los servidores DNS que usan dentro de sus propios archivos de configuración y los manipulan allí de forma autónoma (por ejemplo NetworkManager usa /var/run/NetworkManager/resolv.conf, «systemd-resolved» usa /run/systemd/resolve/resolv.conf, «Networking» usa la línea dns-nameservers dentro de /etc/network/interfaces, etc) pero además siempre vinculan en forma de enlace simbólico su archivo propio respectivo al archivo común /etc/resolv.conf para que los programas que utilicen este archivo común no tengan problemas en encontrar los servidores DNS.

## Establecer una configuración de red estática de forma temporal

- Para asignar una IP / máscara concreta a una tarjeta: 
`ip address add v.x.y.z/n dev nomTarjeta`

- Para borrar una IP / máscara concreta de una tarjeta: `ip address del v.x.y.z / n dev nomTarjeta`

> NOTA: También se puede hacer `ip address flush dev nomTarjeta` si lo que se quiere es borrar de golpe cualesquiera de las eventuales diferentes direcciones IP que pueda tener la tarjeta indicada

 Para asignar la puerta de enlace concreta a una tarjeta: `ip route add default vía v.x.y.z dev nomTarjeta`. Antes, sin embargo, debería borrar la que había asignada antes (si no se hace da error), así: `ip route del default dev nomTarjeta`.

> NOTA: También se puede escribir `ip route add 0.0.0.0/0 vía v.x.y.z dev nomTarjeta`. Es equivalente.

> NOTA: De forma alternativa, en vez de hacer `ip route del … ` y después `ip route add …`, el cambio de puerta de enlace predeterminada se podría hacer directamente en un solo paso, así: `ip route change default vía v.x.y.z dev nomTarjeta`

> NOTA: También se puede indicar que se quiere utilizar una determinada puerta de enlace sólo para llegar a una red-destino concreta. En este caso, entonces, no estaríamos hablando de puerta de enlace «por defecto» sino de una puerta de enlace «específica». La puerta de enlace «por defecto» sería usada una vez que el sistema hubiera comprobado que el destino deseado no forma parte del conjunto de destinos indicados en puertas de enlace específicas. Para crear una puerta de enlace específica hay que ejecutar el comando `ip route add ip.red.Destino/Mascara vía v.x.y.z dev nomTarjeta` Se puede añadir además un último parámetro metric n, que indica la preferencia de la ruta en el caso de que hubieran varias que llevaran al mismo destino (a modo de «backup»): un n menor indica una mayor preferencia.

>NOTA: Una vez asignada una dirección IP a una tarjeta, el sistema calcula automáticamente su dirección IP de red correspondiente y genera una ruta a ella (es por eso que es necesario indicar la máscara en ip address add …)
Por ejemplo, si se asigna la IP 203.0.113.25/24 a la tarjeta enp0s3, se creará automáticamente una ruta en la red 203.0.113.0/24 directa, por lo que el sistema sabrá que para comunicarse con hosts de esta red no necesitará ninguna puerta de enlace intermediaria sino que lo podrá hacer directamente.

##Establecer una configuración estática de forma permanente (en sistemas Debian clásicos)

Todos los comandos anteriores, sin embargo, sólo «funcionan» mientras la máquina se mantiene encendida: si apaga entonces las direcciones IP / máscaras y puertas de enlace configuradas con las órdenes «ip» anteriores se pierden y hay, pues, que volver a ejecutarlas de nuevo en el siguiente inicio.

Para que la configuración deseada de IP / máscara y puerta de enlace (y servidor DNS también, gestionado con alguno de los programas comentados en párrafos anteriores) para una determinada tarjeta de red se mantenga de forma permanente en cada reinicio de la máquina, hay que escribir los valores adecuados en un determinado archivo. En sistemas Debian/Ubuntu, este archivo se denomina /etc/network/interfaces y debe tener un aspecto similar al siguiente (las líneas que comienzan por # son comentarios, las tabulaciones son opcionales):
        
    # Las líneas "auto" sirven para activar la tarjeta en cuestión (en este #caso la tarjeta "lo")
    auto lo
    # La línea siguiente indica que la tarjeta "lo" es de 
    # tipo "loopback" (y que, por tanto, tendrá la IP 127.0.0.1)
    iface lo inet loopback
    # En el mismo archivo se pueden configurar todas las tarjetas que 
    # se quieran: la siguiente se llama enp3s0
    auto enp3s0
    # La palabra "static" indica que los valores de IP, máscara, etc 
    # son fijos en cada reinicio
    iface enp3s0 inet static
    # A continuación se indican los valores de IP, máscara, puerta de 
    # enlace y servidores DNS que se quieren asignar
    address v.x.y.z
    netmask w.w.w.w
    gateway v.x.y.z
    dns-nameservers v.x.y.z v.x.y.z
    

>NOTA: Atención, la línea «**dns-nameservers**» del archivo anterior sólo funciona (es decir, se copian los servidores DNS indicados allí en el archivo central del sistema donde deben estar para ser utilizados: /etc/resolv.conf) si hay instalado un paquete llamado «**resolvconf**». Si no lo está, estas líneas no se  tendrán en cuenta.

Este archivo es leído por un servicio del sistema (un demonio) que se pone en marcha automáticamente al arrancar la máquina y que se denomina «networking». Esto quiere decir que en cualquier momento que hagamos un cambio dentro de este archivo, para que se tenga en cuenta o bien habrá que reiniciar la máquina o bien simplemente reiniciar el servicio, así: `sudo systemctl restart networking`

## Establecer una configuración estática de forma permanente (en sistemas systemd)

**«Systemd-networkd»** es un demonio que gestiona las configuraciones de las diferentes interfaces de red (físicas y / o virtuales) de un sistema systemd, representando, pues, una alternativa al demonio «Networking» de sistemas Debian así como también al scripts ifcfg- * clásicos de Fedora / Suse o al Network Manager integrado en muchos escritorios.

Para empezar a utilizar este demonio es recomendable detener primero la «competencia», por ejemplo, en el caso de Ubuntu ejecutando

`sudo sytemctl disable networking && sudo systemctl stop networking)`

Y entonces encenderlo junto con el servicio «systemd-resolved», así, por ejemplo:

`sudo sytemctl enable systemd-networkd && sudo systemctl start systemd-networkd && sudo sytemctl enable systemd-resolved && sudo systemctl start systemd-resolved`
!!! NOTE
    Al igual que ocurría con el paquete «resolvconf» en los sistemas Debian, se necesita tener un servicio adicional instalado (y funcionando) en el sistema llamado «systemd-resolved» si se quieren especificar entradas DNS explícitas en los archivos .network (o bien si se obtienen vía DHCP). Este servicio lo que hace es, a partir de estas entradas, modificar el archivo /run/systemd/resolve/resolv.conf, el cual, por compatibilidad con muchos programas tradicionales, debería apuntar en forma de enlace suave en /etc/resolv.conf (ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf). Alternativamente, se puede no utilizar systemd-resolved y modificar entonces el archivo /etc/resolv.conf a mano.

Se pueden ver el nombre (y tipo y estado) de las interfaces de red actualmente reconocidas en el sistema (y su tipo y estado) mediante el comando `networkctl list`. Si en la columna SETUP aparece «unmanaged» significa que esta interfaz concreta no es gestionada por systemd-networkd sino por algún otro servicio alternativo. Otra orden que da más información es `networkctl status`. En cualquier caso, para hacer que se gestione por systemd-networkd, por cada interfaz hay que crear un archivo * .network dentro de la carpeta /etc/systemd/network (y reiniciar el servicio). En el caso concreto de querer asignar una IP estática, sería necesario, pues, tener un archivo como este (llamado por ejemplo «/etc/systemd/network/lalala.network «):
```text
[Match]
Name=enp1s0
#Identifica la tarjeta a la cual se le aplicará la configuración
[Network]
DHCP=no
Address=10.1.10.9/24
Gateway=10.1.10.1
DNS=10.1.10.2 #Opcional (Es necesario tener el servicio systemd-resolved funcionando)
DNS=10.1.10.3 #Cada servidor DNS ha d'indicar-se en una línia separada
```
Los archivos de configuración de systemd-networkd proporcionados por la distribución se encuentran en /usr/lib/systemd/network y los administrados por nosotros se tienen que ubicar en /etc/systemd/network. Todos estos archivos se leen -sin distinción de donde estén ubicados – en orden alfanumérico según el nombre que tienen, ganando siempre la primera configuración encontrada en caso de que afectara a la misma tarjeta. Eso sí, si en las dos carpetas se encuentra un fichero con el mismo nombre, lo que hay bajo /etc/systemd/network anula siempre a lo que hay en /usr/lib/systemd/network (una consecuencia de esto es que si el archivo en /etc/… apunta a /dev/null, lo que se estará haciendo es deshabilitar.

Existen tres tipos diferentes de archivos de configuración:

- los «.network» aplican la configuración descrita bajo su sección [Network] a aquellas tarjetas de red que tengan una característica que concuerde con todos los valores indicados en las diferentes líneas bajo la sección [Match] (normalmente aquí sólo indica su nombre mediante una única línea «Name =»)
- los «.netdev» sirven para crear nuevas interfaces de red de tipo virtual ( «bridges», «bonds», etc) -la configuración de red se seguirá indicando en su correspondiente archivo .network)
- los «.link» sirven para definir nombres alternativos a las tarjetas de red en el momento de ser reconocidas por el sistema (vía systemd-udev).

En las líneas bajo la sección [Match] -por ejemplo, en «Name =», se puede utilizar el comodín *. En esta línea en concreto también se puede escribir un conjunto de nombres separados por un espacio en blanco a modo de diferentes alternativas.

En los archivos .network puede haber una sección (no vista en los ejemplos anteriores) titulada [Link] bajo la que pueden haber varias líneas más relacionadas con el comportamiento «hardware» de la tarjeta, como la línea «MACAddress = xx: xx: xx: xx: xx: xx», la cual sirve para asignar a la tarjeta en cuestión una dirección MAC ficticia, la línea «MTUBytes = no», la cual sirve para indicar el tamaño de la MTU admitida (útil por ejemplo para activar los «jumbo frames» si se pone 9000 como valor), o la línea «ARP = no» para desactivar el protocolo ARP en la tarjeta en cuestión (activado por defecto).

Los archivos .netdev suelen tener sólo una sección titulada [netdev], la cual debe incluir dos líneas obligatoriamente: «Name =» (por asignar un nombre a la interfaz virtual que se creará) y «Kind =» (para especificar el tipo de interfaz que será: «bridge», «bond», «Vlan», «veth», etc). En el caso de que sea de tipo «vlan», aparecerá entonces una sección titulada [VLAN] incluyendo como mínimo la línea «Id =» para indicar el número de VLAN que se está creando.

Los archivos .link suelen tener una sección [Match] con la línea «MACAddress =» para identificar la tarjeta de red en cuestión y una sección
[Link] que sirve para manipular las características de esta tarjeta, como por ejemplo su nombre (con la línea «Name =» y, opcionalmente, la línea «Description =»). Si no se crea manualmente ningún archivo .link, la mayoría de distribuciones ofrecen un archivo .link predeterminado, generalmente llamado 99-default.link (y ubicado en / usr / lib / systemd / network); es por ello que hay que asegurarse que los ficheros .link «manuales» tengan un nombre que asegure su lectura antes de la del archivo 99-default.link.

Para más información sobre las posibilidades que ofrecen todos estos archivos, consultar las páginas del manual «systemd.network», «Systemd.netdev» y «systemd.link».

!!! warning "Atención"

    No sólo existen el servicio «networking» y «systemd-networkd» para gestionar las tarjetas de red de nuestro sistema. También podemos encontrar el servicio «NetworkManager» (sobre todo en sistemas con escritorio) y en las últimas versiones de Ubuntu el servicio «Netplan», entre otros. !!!


##Establecer una configuración dinámica de forma temporal

En las configuraciones anteriores, tanto la temporal como la permanente, se establece una dirección IP / máscara + puerta de enlace concreta, decidida por nosotros. Este método puede ser útil para pocas máquinas, pero en una red con muchos equipos, puede llegar a ser bastante farragoso, además de que fácilmente se pueden cometer errores (IPs duplicadas, IP no asignadas).

Otro método para establecer estos datos es el método «dinámico», en el que la máquina en cuestión no tiene asignada de forma fija IP / máscara + puerta de enlace + servidor DNS sino que estos datos los obtiene de la red: allí deberá haber escuchando un ordenador ejecutando un software especial llamado «Servidor DHCP», el cual sirve precisamente para atender estas peticiones de «datos de red» y asignarlas a quien las pida. De este modo, se tiene una gestión centralizada del reparto de direcciones IP / máscara + puerta de enlace + servidores DNS sin necesidad de realizar ninguna configuración específica en las máquinas clientes. Eso sí, claro: primero se deberá haber instalado y configurado convenientemente en nuestra red este software «servidor DHCP» (un ejemplo es el paquete «isc-dhcp-server «), tarea que no veremos (se presupone que esto ya está hecho).

!!!NOTE "Nota"
    Otro cliente similar es el comando host nomDNS [ip.serv.DNS]


Para pedir en un momento determinado una configuración completa de red (IP, máscara, puerta de enlace, servidores DNS, etc) a un servidor DHCP ya funcionando en nuestra LAN hemos de ejecutar un cliente DHCP, como el comando `dhclient`
`Dhclient nomTarjeta` Pide -para la tarjeta indicada- los datos de red (IP, máscara, puerta de enlace, servidor DNS, etc) a algún servidor DHCP que esté escuchando a la LAN de nuestra máquina.

-v Muestra por pantalla todo el proceso de petición y respuesta (útil para ver si va)

-r Borra todos los datos de red que pueda tener actualmente la tarjeta indicada


##Establecer una configuración dinámica de forma permanente
###En sistemas Debian clásicos

Para pedir los datos de red a algún servidor DHCP de nuestra red, en vez
de tener que hacerlo manualmente con el comando ` dhclient`, se puede hacer de forma automática cada vez que nuestra máquina arranque (de modo que nosotros no tengamos que hacer nada y ya tengamos, si todo va bien, estos datos ya asignadas una vez iniciamos sesión). Esto se logra simplemente escribiendo las siguientes líneas en el archivo /etc/network/interfaces:
```TEXT
auto enp3s0
iface enp3s0 inet dhcp
```
### En sistemas systemd
En el caso concreto de querer asignar una IP dinámica en un sistema con el demonio systemd-netword funcionando, habrá que tener un archivo como este (llamado por ejemplo «/Etc/systemd/network/lalala.network»):
```TEXT
[Match]
Name = enp1s0
[Network]
DHCP = yes # También podría valer ipv4 o ipv6 según el tipo de direcciones IP que queremos recibir
```


##ping
`ping ip o Nombre Maq. Remota` 

Comprueba si la máquina remota indicada responde. Sirve, por tanto, para saber si hay conexión de red con aquella máquina (si no, podría ser debido a cualquier causa: cable mal enchufado o roto, máquina remota apagada, etc). En este sentido, son interesantes los datos estadísticos que aparecen al final (paquetes enviados, recibidos, perdidos, etc) y el tiempo que han tardado en enviarse estos paquetes de prueba (y recibirse la respuesta) -y así comprobar la saturación del medio.

-n No resuelve nombres (es decir, no hace la consulta previa en el servidor DNS del sistema). Por lo tanto, sólo hace que funcione indicando direcciones IP

-c nº Número de paquetes de prueba que se enviarán (si no se indica, son infinitos y hay que detener el envío pulsando CTRL + C)

-i nºNúmero de segundos que se espera para enviar el siguiente paquete

-f Mode «flood». Envía paquetes a la máxima velocidad posible, mostrando un punto por cada paquete enviado y borrándose el por cada respuesta recibida: por lo tanto, para ir bien habría que sólo se viera un punto y fuera desapareciendo: si se ven muchos puntos es que hay pérdida de paquetes. Hay que ser root para que funcione

-I eno1 Indica la tarjeta de red para la que se enviarán los paquetes (por si la máquina tuviera más de una)

##mtr

`mtr ip.o Nom.Maq.Remota`

Sirve para conocer el camino seguido por un paquete desde la máquina origen hasta la indicada, mostrando la IP (o nombre) de todos los routers
intermedios a través de los que va pasando. también muestra estadísticas de tiempo empleado en cada paquete, el mejor tiempo, el peor, los paquetes perdidos, etc

-n No resuelve nombres (es decir, no hace la consulta previa en el servidor DNS del sistema).

-c nº Número de paquetes de prueba que se enviarán (si no se indica, son infinitos y hay que parar el envío pulsando CTRL + C)

-i nº Número de segundos que se espera para enviar el siguiente paquete