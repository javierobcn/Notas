##Networking

###OSI Stack

![Screenshot](assets/osi_stack.jpg)

Se recomienda una lectura efusiva de libros relacionados

###Redes TCP/IP
#### Cálculo de máscaras/rangos de red
En las redes TCP/IP el funcionamiento del cálculo de máscaras de red o rangos IP és exactamente igual:

Las  direcciones IP (192.168.1.0) al igual que sus máscaras de red estan  formadas por 4 números decimales de entre 1 y 3 dígitos que van del 0 al 255 ( nº max. de combinaciones posibles con 8 bits --> (2^8)-2=254  ya que el 0 y el 255 están reservados para rango IP y broadcast  respectivamente ) por lo que nos quedaría:
```
     
            DEC                             BIN
--------------------------------------------------------------------

Ej.IP   192.168.1.0     11000000 10101000 00000001 00000000

Ej.Mask 255.255.0.0     11111111 11111111 00000000 00000000
        255.255.255.0   11111111 11111111 11111111 00000000

```

Tenemos varias formas de expresar la mascara,  en binario como en el ejemplo anterior, en notación decimal ( lo más  común ) o bien al lado de la IP con una barra ( ej IP/MASK ->>  192.168.1.0/24 (CIDR))
           
```
Tabla de máscaras de red
MÁSCARAS DE RED Binario             Decimal                             CIDR
+--------------------------------------------------------------------------------------------------------+
11111111.11111111.11111111.11111111         255.255.255.255             /32
11111111.11111111.11111111.11111110         255.255.255.254             /31
11111111.11111111.11111111.11111100         255.255.255.252             /30
11111111.11111111.11111111.11111000         255.255.255.248             /29
11111111.11111111.11111111.11110000         255.255.255.240             /28
11111111.11111111.11111111.11100000         255.255.255.224             /27
11111111.11111111.11111111.11000000         255.255.255.192             /26
11111111.11111111.11111111.10000000         255.255.255.128             /25
11111111.11111111.11111111.00000000         255.255.255.0               /24
11111111.11111111.11111110.00000000         255.255.254.0               /23
11111111.11111111.11111100.00000000         255.255.252.0               /22
11111111.11111111.11111000.00000000         255.255.248.0               /21
11111111.11111111.11110000.00000000         255.255.240.0               /20
11111111.11111111.11100000.00000000         255.255.224.0               /19
11111111.11111111.11000000.00000000         255.255.192.0               /18
11111111.11111111.10000000.00000000         255.255.128.0               /17
11111111.11111111.00000000.00000000         255.255.0.0                 /16
11111111.11111110.00000000.00000000         255.254.0.0                 /15
11111111.11111100.00000000.00000000         255.252.0.0                 /14
11111111.11111000.00000000.00000000         255.248.0.0                 /13
11111111.11110000.00000000.00000000         255.240.0.0                 /12
11111111.11100000.00000000.00000000         255.224.0.0                 /11
11111111.11000000.00000000.00000000         255.192.0.0                 /10
11111111.10000000.00000000.00000000         255.128.0.0                 /9
11111111.00000000.00000000.00000000         255.0.0.0                   /8
11111110.00000000.00000000.00000000         254.0.0.0                   /7
11111100.00000000.00000000.00000000         252.0.0.0                   /6
11111000.00000000.00000000.00000000         248.0.0.0                   /5
11110000.00000000.00000000.00000000         240.0.0.0                   /4
11100000.00000000.00000000.00000000         224.0.0.0                   /3
11000000.00000000.00000000.00000000         192.0.0.0                   /2
10000000.00000000.00000000.00000000         128.0.0.0                   /1
00000000.00000000.00000000.00000000         0.0.0.0                     /0

```

Vamos a tomar como ejemplo la dirección de red 192.168.0.0 con mascara de subred 255.255.255.0.

Teniendo esta dirección de red (u otra dirección de clase C con mascara de subred por defecto) solo podremos tener 254 hosts.
Veamos por que:

La  mascara de subred por defecto de una dirección IP de clase C nos dice  que solo el ultimo octeto esta destinado a hosts. Esos 8 números del  último octeto, equivalen a 256 números posibles (2^8 = 256).

Pero por que antes dije que solo 254 eran validos?
De  esos 256 números posibles, hay solo 2 que no podremos usar para un  host: El 192.168.0.0 y el 192.168.0.255, ya que esas dos direcciones son  las direcciones de red y difusión respectivamente.

Entonces, (2^8) - 2 = 254.

Pero, que pasa si yo se que solo voy a usar 10 de esas 254 direcciones?
Como decía antes, las subredes pueden ayudarnos, entre otras cosas, a aprovechar direcciones IP.
Siguiendo  con el ejemplo: Si tenemos la dirección 192.168.0.0 con mascara de  subred 255.255.255.0, podemos utilizar por ejemplo 4 de esos 8 bits,  para armar subredes.

En este caso, la mascara de subred seria 11111111.11111111.11111111.11110000 o 255.255.255.240.

Es decir: Tenemos 24 bits de red, 4 de subred y 4 de host.

Ahora  podremos hacer 14 subredes de 14 host cada una. Y digo 14 y no 16 por  que pasa lo mismo que decía antes: El calculo se hace elevando el numero  2 (binario) a la cantidad de bits para subred (4) - 2 (red y difusión):  (24) – 2 = 14.

La cantidad de hosts se calcula de la misma manera.

Sabiendo esto, podremos enumerar las 14 subredes que podemos hacer

   1. 192.168.0.00010000 (hosts entre .0.17 y .0.30 inclusive)
   2. 192.168.0.00100000 (hosts entre .0.33 y .0.46 inclusive)
   3. 192.168.0.00110000 (hosts entre .0.49 y .0.62 inclusive)
   4. 192.168.0.01000000 (hosts entre .0.65 y .0.78 inclusive)
   5. 192.168.0.01010000 (hosts entre .0.81 y .0.94 inclusive)
   6. 192.168.0.01100000 (hosts entre .0.97 y .0.110 inclusive)
   7. 192.168.0.01110000 (hosts entre .0.113 y .0.126 inclusive)
   8. 192.168.0.10000000 (hosts entre .0.129 y .0.142 inclusive)
   9. 192.168.0.10010000 (hosts entre .0.145 y .0.158 inclusive)
  10. 192.168.0.10100000 (hosts entre .0.161 y .0.174 inclusive)
  11. 192.168.0.10110000 (hosts entre .0.177 y .0.190 inclusive)
  12. 192.168.0.11000000 (hosts entre .0.193 y .0.206 inclusive)
  13. 192.168.0.11010000 (hosts entre .0.209 y .0.222 inclusive)
  14. 192.168.0.11100000 (hosts entre .0.225 y .0.238 inclusive)


### Nomenclatura de tarjetas de red en Linux
Las tarjetas de red en sistemas Linux se pueden llamar de las siguientes maneras:

- **lo**: Corresponde a la tarjeta "loopback". Recordemos que hemos dicho que esta tarjeta físicamente no existe (es un "invento" del sistema operativo) y suele tener siempre tiene la IP 127.0.0.1/8. Sirve para establecer una conexión con sí misma, de tal forma que podemos tener en la misma máquina un programa cliente que conecte a un programa servidor sin salir "fuera".
- **eno1, eno2**: Tarjetas Ethernet integradas en la placa base ( "on-board")
- **ens1, ens2**: Tarjetas Ethernet PCI ( "slot")
- **enp2s0, p3p1**: Tarjetas Ethernet que no se pueden localizar de otra forma debido a limitaciones de la BIOS
- **wlp2s0**:tarjetas WiFi

Dentro de las máquinas virtuales de VirtualBox las tarjetas de red cogen siempre un nombre concreto: la tarjeta correspondiente a la primera pestaña del cuadro de configuración de red se llamará "enp0s3" dentro del sistema virtualizado, la segunda "enp0s8", la tercera "enp0s9" y la cuarta "enp0s10".

#### ifconfig / ip

Mostrar dispositivos de red y configuración

    ifconfig

    ip addr show  / ip a
    ip link show 

habilitar una tarjeta de red

    ifconfig eth0 up
    ip link set eth0 up

deshabilitar una tarjeta de red
    
    ifconfig eth0 down
    ip link set eth0 down


!!! warning "Atención"
    A pesar de que el comando `/bin/ip` es capaz de hacer lo mismo e incluso mas que `ifconfig`, es necesario conocer algo de este comando, aunque utilizaremos siempre que podamos el comando `/bin/ip`

`ifconfig` → a pelo devuelve un listado de las tarjetas de red levantadas y un párrafo descriptivo. 

`ifconfig eth0` → solo muestra info de esta tarjeta de red

`ifconfig <device> <ip> netmask`

`ifconfig eth0:1 10.3.2.1 up` → crear un dispositivo de red virtual (Alias)

`ifconfig <device> <ip> <mask> up/down` (Si no le pones máscara la calcula el)

si hacemos `ifconfig eth0 down` puede perderse la IP

ifconfig eth0 hw ether 02:01:02:03:04:08
confirmar con ifconfig eth0 

####Dirección de loopback o de bucle local
Evita que salgan paquetes al exterior. Se usa para conectarse a servicios que tenemos en la misma máquina.

las tarjetas ethernet se numeran con eth0, eth1, eth2….

Para conexiones wireless utilizamos iwconfig que nos mostrará  los dispositivos wifi compatibles.

utilidad ipcalc (calculadora IP)

ipcalc 10.8.0.0/19

Address:   10.8.0.0             00001010.00001000.000 00000.00000000
Netmask:   255.255.224.0 = 19   11111111.11111111.111 00000.00000000
Wildcard:  0.0.31.255           00000000.00000000.000 11111.11111111
=>
Network:   10.8.0.0/19          00001010.00001000.000 00000.00000000
HostMin:   10.8.0.1             00001010.00001000.000 00000.00000001
HostMax:   10.8.31.254          00001010.00001000.000 11111.11111110
Broadcast: 10.8.31.255          00001010.00001000.000 11111.11111111
Hosts/Net: 8190                 Class A, Private Internet


mac address 

las mac address que muestra ifconfig se pueden falsificar, 

comando macchanger

es buena práctica cambiar la mac address si vamos a trastear.


los cambios hechos así son efímeros, por eso existen unos ficheros de config

ficheros de config de red
Redhat y Debian utilizan distintos ficheros dentro de la carpeta /etc
Redhat 
    /etc/sysconfig/network-scripts/ifcfg
Debian 
    /etc/network/interfaces

https://wiki.debian.org/es/NetworkConfiguration



Ejemplo de fichero /etc/network/interfaces para IP estática


Otros ficheros de configuración

    /etc/hosts
    /etc/resolv.conf
    /etc/network/interfaces

### Comandos básicos de red en Linux
#### Ver la configuración actual
##### Estado y configuración de las tarjetas detectadas
El comando `ip address show` (o bien `ip address show dev nomTarjeta` si sólo se quiere obtener la información de una tarjeta determinada) nos muestra:

- Las direcciones MAC de las tarjetas
- Su estado respectivo (UP, DOWN)
- Sus direcciones IP respectivas (y la máscara correspondiente)
- Otros datos (como si permite el envío "broadcast", si está en modo "promiscuo", etc).

!!!NOTE "NOTA"
    El comando `ip address show` se puede escribir de forma más corta así: `ip a s`. Incluso, se puede dejar de escribir el verbo show (o s) porque es la acción por defecto (por lo tanto, se puede hacer `ip address` o `ip a` y sería lo mismo). También es útil el parámetro -c (así: `ip -c a s`) para ver los datos más relevantes en colores.

Para activar / desactivar una tarjeta: ip link set {up|down} dev nomTarjeta

##### Puerta de enlace
El comando `ip route show` (o bien `ip route show dev nomTarjeta` o sus variantes `ip route`, `ip r s` o `ip r`) debe mostrar una línea que comenzará con la expresión **"default vía"** seguida de la dirección IP de la puerta de enlace establecida. 
Este comando puede mostrar más líneas, pero no nos interesarán mucho ... (quizás la más curiosa es una que sirve para indicar que no hay ninguna puerta de enlace para comunicarse con las máquinas que pertenezcan a la misma red a la que pertenece nuestra máquina).

##### DNS
Para saber la dirección IP del servidor DNS configurado en nuestra máquina (o las IPs … si hay más de una se prueba conectar a la primera y si esta falla entonces se prueba la segunda, y así) se puede consultar el archivo `etc/resolv.conf` (concretamente, las líneas que comienzan por la palabra nameserver). Estos servidores serán los que todas las aplicaciones del sistema (desde el ping hasta el navegador) utilizarán para averiguar cuál es la IP del nombre que el usuario haya escrito.

El contenido de este archivo suele ser gestionado por diferentes programas (como puede ser el cliente **dhclient**, la aplicación **NetworkManager**, el servicio **networking**, el servicio **systemd-networkd/resolved**, etc) y es por ello que no se recomienda modificarlo manualmente ya que los cambios realizados a mano podrían «Machacar» sin avisar en cualquier momento por cualquiera de estos programas.

En este sentido, estos programas (**dhclient, NetworkManager, «networking», «systemd-networkd / resolved, etc**) guardan los servidores DNS que usan dentro de sus propios archivos de configuración y los manipulan allí de forma autónoma (por ejemplo NetworkManager usa /var/run/NetworkManager/resolv.conf, «systemd-resolved» usa /run/systemd/resolve/resolv.conf, «Networking» usa la línea dns-nameservers dentro de /etc/network/interfaces, etc) pero además siempre vinculan en forma de enlace simbólico su archivo propio respectivo al archivo común /etc/resolv.conf para que los programas que utilicen este archivo común no tengan problemas en encontrar los servidores DNS.

#### Establecer una configuración de red estática de forma temporal

- Para asignar una IP / máscara concreta a una tarjeta: 
`ip address add v.x.y.z/n dev nomTarjeta`

- Para borrar una IP / máscara concreta de una tarjeta: `ip address del v.x.y.z / n dev nomTarjeta`

!!!NOTE "NOTA"
    También se puede hacer `ip address flush dev nomTarjeta` si lo que se quiere es borrar de golpe cualesquiera de las eventuales diferentes direcciones IP que pueda tener la tarjeta indicada

 Para asignar la puerta de enlace concreta a una tarjeta: `ip route add default vía v.x.y.z dev nomTarjeta`. Antes, sin embargo, debería borrar la que había asignada antes (si no se hace da error), así: `ip route del default dev nomTarjeta`.

!!!NOTE "NOTA"
    También se puede escribir `ip route add 0.0.0.0/0 vía v.x.y.z dev nomTarjeta`. Es equivalente.

!!!NOTE "NOTA"
    De forma alternativa, en vez de hacer `ip route del … ` y después `ip route add …`, el cambio de puerta de enlace predeterminada se podría hacer directamente en un solo paso, así: `ip route change default vía v.x.y.z dev nomTarjeta`

!!!NOTE "NOTA"
    También se puede indicar que se quiere utilizar una determinada puerta de enlace sólo para llegar a una red-destino concreta. En este caso, entonces, no estaríamos hablando de puerta de enlace «por defecto» sino de una puerta de enlace «específica». La puerta de enlace «por defecto» sería usada una vez que el sistema hubiera comprobado que el destino deseado no forma parte del conjunto de destinos indicados en puertas de enlace específicas. Para crear una puerta de enlace específica hay que ejecutar el comando `ip route add ip.red.Destino/Mascara vía v.x.y.z dev nomTarjeta` Se puede añadir además un último parámetro metric n, que indica la preferencia de la ruta en el caso de que hubieran varias que llevaran al mismo destino (a modo de «backup»): un n menor indica una mayor preferencia.

!!!NOTE "NOTA"
    Una vez asignada una dirección IP a una tarjeta, el sistema calcula automáticamente su dirección IP de red correspondiente y genera una ruta a ella (es por eso que es necesario indicar la máscara en ip address add …)
    Por ejemplo, si se asigna la IP 203.0.113.25/24 a la tarjeta enp0s3, se creará automáticamente una ruta en la red 203.0.113.0/24 directa, por lo que el sistema sabrá que para comunicarse con hosts de esta red no necesitará ninguna puerta de enlace intermediaria sino que lo podrá hacer directamente.

####Establecer una configuración estática de forma permanente 
#####En sistemas Debian clásicos

Todos los comandos anteriores, sin embargo, sólo «funcionan» mientras la máquina se mantiene encendida: si apaga entonces las direcciones IP / máscaras y puertas de enlace configuradas con las órdenes «ip» anteriores se pierden y hay, pues, que volver a ejecutarlas de nuevo en el siguiente inicio.

Para que la configuración deseada de IP / máscara y puerta de enlace (y servidor DNS también, gestionado con alguno de los programas comentados en párrafos anteriores) para una determinada tarjeta de red se mantenga de forma permanente en cada reinicio de la máquina, hay que escribir los valores adecuados en un determinado archivo. En sistemas Debian/Ubuntu, este archivo se denomina /etc/network/interfaces y debe tener un aspecto similar al siguiente (las líneas que comienzan por # son comentarios, las tabulaciones son opcionales):
```text        
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
```

!!!WARNING "Atención"
    Atención, la línea «**dns-nameservers**» del archivo anterior sólo funciona (es decir, se copian los servidores DNS indicados allí en el archivo central del sistema donde deben estar para ser utilizados: /etc/resolv.conf) si hay instalado un paquete llamado «**resolvconf**». Si no lo está, estas líneas no se  tendrán en cuenta.

Este archivo es leído por un servicio del sistema (un demonio) que se pone en marcha automáticamente al arrancar la máquina y que se denomina «networking». Esto quiere decir que en cualquier momento que hagamos un cambio dentro de este archivo, para que se tenga en cuenta o bien habrá que reiniciar la máquina o bien simplemente reiniciar el servicio, así: `sudo systemctl restart networking`

#####En sistemas systemd

**«Systemd-networkd»** es un demonio que gestiona las configuraciones de las diferentes interfaces de red (físicas y / o virtuales) de un sistema systemd, representando, pues, una alternativa al demonio «Networking» de sistemas Debian así como también al scripts ifcfg- * clásicos de Fedora / Suse o al Network Manager integrado en muchos escritorios.

Para empezar a utilizar este demonio es recomendable detener primero la «competencia», por ejemplo, en el caso de Ubuntu ejecutando

`sudo sytemctl disable networking && sudo systemctl stop networking)`

Y entonces encenderlo junto con el servicio «systemd-resolved», así, por ejemplo:

`sudo sytemctl enable systemd-networkd && sudo systemctl start systemd-networkd && sudo sytemctl enable systemd-resolved && sudo systemctl start systemd-resolved`
!!! NOTE
    Al igual que ocurría con el paquete «resolvconf» en los sistemas Debian, se necesita tener un servicio adicional instalado (y funcionando) en el sistema llamado «systemd-resolved» si se quieren especificar entradas DNS explícitas en los archivos .network (o bien si se obtienen vía DHCP). Este servicio lo que hace es, a partir de estas entradas, modificar el archivo /run/systemd/resolve/resolv.conf, el cual, por compatibilidad con muchos programas tradicionales, debería apuntar en forma de enlace suave en /etc/resolv.conf (ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf). Alternativamente, se puede no utilizar systemd-resolved y modificar entonces el archivo /etc/resolv.conf a mano.

Se pueden ver el nombre (y tipo y estado) de las interfaces de red actualmente reconocidas en el sistema (y su tipo y estado) mediante el comando `networkctl list`. Si en la columna SETUP aparece «unmanaged» significa que esta interfaz concreta no es gestionada por systemd-networkd sino por algún otro servicio alternativo. Otra orden que da más información es `networkctl status`. En cualquier caso, para hacer que se gestione por systemd-networkd, por cada interfaz hay que crear un archivo * .network dentro de la carpeta /etc/systemd/network (y reiniciar el servicio). En el caso concreto de querer asignar una IP estática, sería necesario, pues, tener un archivo como este (llamado por ejemplo `/etc/systemd/network/lalala.network`):

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
Los archivos de configuración de systemd-networkd proporcionados por la distribución se encuentran en `/usr/lib/systemd/network` y los administrados por nosotros se tienen que ubicar en `/etc/systemd/network`. Todos estos archivos se leen -sin distinción de donde estén ubicados – en orden alfanumérico según el nombre que tienen, ganando siempre la primera configuración encontrada en caso de que afectara a la misma tarjeta. Eso sí, si en las dos carpetas se encuentra un fichero con el mismo nombre, lo que hay bajo `/etc/systemd/network` anula siempre a lo que hay en `/usr/lib/systemd/network` (una consecuencia de esto es que si el archivo en /etc/… apunta a /dev/null, lo que se estará haciendo es deshabilitar.

Existen tres tipos diferentes de archivos de configuración:

- los **«.network»** aplican la configuración descrita bajo su sección [Network] a aquellas tarjetas de red que tengan una característica que concuerde con todos los valores indicados en las diferentes líneas bajo la sección [Match] (normalmente aquí sólo indica su nombre mediante una única línea «Name =»)
- los **«.netdev»** sirven para crear nuevas interfaces de red de tipo virtual ( «bridges», «bonds», etc) -la configuración de red se seguirá indicando en su correspondiente archivo .network)
- los **«.link»** sirven para definir nombres alternativos a las tarjetas de red en el momento de ser reconocidas por el sistema (vía systemd-udev).

En las líneas bajo la sección [Match] -por ejemplo, en «Name =», se puede utilizar el comodín *. En esta línea en concreto también se puede escribir un conjunto de nombres separados por un espacio en blanco a modo de diferentes alternativas.

En los archivos .network puede haber una sección (no vista en los ejemplos anteriores) titulada [Link] bajo la que pueden haber varias líneas más relacionadas con el comportamiento «hardware» de la tarjeta, como la línea «MACAddress = xx: xx: xx: xx: xx: xx», la cual sirve para asignar a la tarjeta en cuestión una dirección MAC ficticia, la línea «MTUBytes = no», la cual sirve para indicar el tamaño de la MTU admitida (útil por ejemplo para activar los «jumbo frames» si se pone 9000 como valor), o la línea «ARP = no» para desactivar el protocolo ARP en la tarjeta en cuestión (activado por defecto).

Los archivos .netdev suelen tener sólo una sección titulada [netdev], la cual debe incluir dos líneas obligatoriamente: «Name =» (por asignar un nombre a la interfaz virtual que se creará) y «Kind =» (para especificar el tipo de interfaz que será: «bridge», «bond», «Vlan», «veth», etc). En el caso de que sea de tipo «vlan», aparecerá entonces una sección titulada [VLAN] incluyendo como mínimo la línea «Id =» para indicar el número de VLAN que se está creando.

Los archivos .link suelen tener una sección [Match] con la línea «MACAddress =» para identificar la tarjeta de red en cuestión y una sección
[Link] que sirve para manipular las características de esta tarjeta, como por ejemplo su nombre (con la línea «Name =» y, opcionalmente, la línea «Description =»). Si no se crea manualmente ningún archivo .link, la mayoría de distribuciones ofrecen un archivo .link predeterminado, generalmente llamado 99-default.link (y ubicado en / usr / lib / systemd / network); es por ello que hay que asegurarse que los ficheros .link «manuales» tengan un nombre que asegure su lectura antes de la del archivo 99-default.link.

Para más información sobre las posibilidades que ofrecen todos estos archivos, consultar las páginas del manual «systemd.network», «Systemd.netdev» y «systemd.link».

!!! warning "Atención"

    No sólo existen el servicio «networking» y «systemd-networkd» para gestionar las tarjetas de red de nuestro sistema. También podemos encontrar el servicio «NetworkManager» (sobre todo en sistemas con escritorio) y en las últimas versiones de Ubuntu el servicio «Netplan», entre otros. !!!


####Establecer una configuración dinámica de forma temporal

En las configuraciones anteriores, tanto la temporal como la permanente, se establece una dirección IP / máscara + puerta de enlace concreta, decidida por nosotros. Este método puede ser útil para pocas máquinas, pero en una red con muchos equipos, puede llegar a ser bastante farragoso, además de que fácilmente se pueden cometer errores (IPs duplicadas, IP no asignadas).

Otro método para establecer estos datos es el método «dinámico», en el que la máquina en cuestión no tiene asignada de forma fija IP / máscara + puerta de enlace + servidor DNS sino que estos datos los obtiene de la red: allí deberá haber escuchando un ordenador ejecutando un software especial llamado «Servidor DHCP», el cual sirve precisamente para atender estas peticiones de «datos de red» y asignarlas a quien las pida. De este modo, se tiene una gestión centralizada del reparto de direcciones IP / máscara + puerta de enlace + servidores DNS sin necesidad de realizar ninguna configuración específica en las máquinas clientes. Eso sí, claro: primero se deberá haber instalado y configurado convenientemente en nuestra red este software «servidor DHCP» (un ejemplo es el paquete «isc-dhcp-server «), tarea que no veremos (se presupone que esto ya está hecho).

!!!NOTE "Nota"
    Otro cliente similar es el comando host nomDNS [ip.serv.DNS]


Para pedir en un momento determinado una configuración completa de red (IP, máscara, puerta de enlace, servidores DNS, etc) a un servidor DHCP ya funcionando en nuestra LAN hemos de ejecutar un cliente DHCP, como el comando `dhclient`

`Dhclient nomTarjeta` Pide -para la tarjeta indicada- los datos de red (IP, máscara, puerta de enlace, servidor DNS, etc) a algún servidor DHCP que esté escuchando a la LAN de nuestra máquina.

**-v** Muestra por pantalla todo el proceso de petición y respuesta (útil para ver si va)

**-r** Borra todos los datos de red que pueda tener actualmente la tarjeta indicada


####Establecer una configuración dinámica de forma permanente
#####En sistemas Debian clásicos

Para pedir los datos de red a algún servidor DHCP de nuestra red, en vez
de tener que hacerlo manualmente con el comando ` dhclient`, se puede hacer de forma automática cada vez que nuestra máquina arranque (de modo que nosotros no tengamos que hacer nada y ya tengamos, si todo va bien, estos datos ya asignadas una vez iniciamos sesión). Esto se logra simplemente escribiendo las siguientes líneas en el archivo /etc/network/interfaces:
```
auto enp3s0
iface enp3s0 inet dhcp
```
#####En sistemas systemd
En el caso concreto de querer asignar una IP dinámica en un sistema con el demonio systemd-netword funcionando, habrá que tener un archivo como este (llamado por ejemplo `/etc/systemd/network/lalala.network`):
```
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

##ss

Muestra datos sobre las conexiones existentes (o que pueden existir) en
nuestra máquina. Concretamente, muestra el estado de la conexión (los más habituales son ESTABLISHED y LISTEN -este último indica que el
puerto está abierto pero sin conexión -… otros estados a menudo son
temporales y terminan derivando en una conexión establecida o bien
desapareciendo), muestra la IP y el puerto local utilizados para establecer la conexión (o para escuchar, segundos) y la IP y puerto remoto donde la
correspondiente IP + puerto local están conectados.

NOTA: Otro cliente similar es el comando `host nomDNS [ip.serv.DNS]`

-t Mostrar sólo las conexiones TCP actuales

-u Mostrar sólo las conexiones UDP actuales

-n No resuelve nombres (es decir: muestra IPs y puertos en formato numérico en lugar de con nombres)

-a (Combinado con -t y/o -u): Muestra, además de las conexiones actuales, los puertos a la escucha

-l (Combinado con -t y / o -u): Muestra sólo los puertos a la escucha (las conexiones actuales no)

-p (Combinado con -t y / o -u): Muestra 1 columna más: el ejecutable «detrás» de cada puerto local

–s Muestra un resumen con estadísticas

##ncat

`ncat ip.oNom.Maq.Remota noport`

Cliente Netcat que viene dentro del paquete «nmap»: realiza una
conexión (TCP) en la máquina y puerto indicado. Se puede añadir el
parámetro -v (modo verboso) y -n (no resuelve nombres), entre otros.

-v Modo verboso (-vv es más verboso y -vvv más aún)

`ncat -l -k -p nº` Servidor Netcat: pone a la escucha el nº de puerto (TCP) indicado. el argumento -l sirve para «abrir» el puerto, el parámetro -p sirve para indicar el número de puerto a abrir y el parámetro -k permite que se puedan conectar más de un cliente a la vez.

-e /ruta/comando Todo lo que se reciba de la red será pasado al comando indicado, la salida será devuelta al cliente. Si el comando indicado fuera
/Bin/bash, la entrada se entenderá como un comando a ejecutar (y la
salida será la salida del comando ejecutado).
Exemples Ncat


**Chat** 

Servidor: `ncat -l -p 5588` <—> Cliente: `ncat ipServidor 5588`

El servidor se pone a escuchar en el puerto 5588 (por defecto siempre es TCP), con lo que todo lo que le llegue de la red -es decir, del cliente-lo pasará a la stdout (pantalla), y todo lo que escriba por stdin (teclado) pasará a la red -es decir, hacia el cliente-. Lo mismo ocurre en el otro lado de la comunicación. Si se añade el parámetro -k al servidor, múltiples clientes podrán enviar mensajes al servidor y este, lo que envíe, lo enviará a todos sin discriminación

**Envío de un archivo**

Servidor: `ncat -l -p 5555 < archivo` <-> Cliente: `ncat ipServidor 5555 > archivo`

Muy similar a lo anterior: el servidor se pone a escuchar en el puerto 5555, pero en vez de responder por teclado a la stdin, la entrada proviene de un archivo, el cual esperará latente a que cuando se establezca una comunicación por ese puerto, su contenido viaje bit a bit por la red hacia el cliente, el cual lo recibirá y lo guardará en forma de archivo otra vez. Lo malo es que tal como se ha hecho, no se sabe cuándo se ha acabado la transferencia: hay que esperar un tiempo prudencial y entonces hacer Ctrl+C.

**Reproducción de audio en streaming**

Servidor: `ncat -l -p 5858` Cliente: `ncat ipServidor 5858 | mpg123 –`

El ejemplo es idéntico al anterior, teniendo un archivo en este caso de audio. La única diferencia es que en el cliente, el archivo no se redirecciona para grabarlo en disco sino que se entuba a un reproductor de audio por consola, como mpg123 (el guión del final es para indicarle que el fichero o lista de reproducción le proviene de la tubería).


**Clonación de discos por red**

Servidor: `ncat -l -p 5678 | dd of=a.iso.gz` <—->Cliente: `dd if=/dev/sda | gzip -c | ncat ipServidor 5678`

El ejemplo es parecido al anterior: primero en el cliente se comprime bit a bit el contenido del disco «sda» y se le envía ya comprimido al servidor, el cual recibe este contenido binario y lo almacena en un archivo, bit a bit too.

##nmap

`nmap -sn { ipInici-ipFinal [altraIP …] | ipConAsteriscos }`

Muestra qué ordenadores están presentes en la red. existen muchos otros parámetros de escaneo (-sU, -sX, -sF, etc) que utilizan diferentes técnicas más
o – rápidas / sigilosas / precisas, pero no las veremos.

-v Modo verboso (-vv es más verboso y -vvv más aún)

-n No resuelve nombres

`nmap -p nº, nº-nº ipOrdenador` Muestra qué puertos (del rango indicado) tiene abiertos un ordenador concreto. Aquí también se pueden utilizar diferentes técnicas pero tampoco profundizaremos

-O Muestra el sistema operativo del ordenador y los programas «detrás» de los
puertos abiertos. Se puede combinar con el parámetro -sV, el cual muestra también las versiones. El parámetro -A es la combinación de los dos.

##nslookup

`nslookup nombreDNS [ip.serv.DNS]`

Cliente DNS que pregunta al servidor indicado o, si no se indica ninguno, al que esté configurado en `/etc/resolv.conf`. Normalmente, además de devolver la IP (o IPs equivalentes) asociadas al nombre indicado, también muestra los «alias» que tiene este nombre

!!!NOTE "NOTA"
    Otro cliente similar es el comando `host nomDNS [ip.serv.DNS]`

!!!NOTE "NOTA"
    Otro cliente similar es el comando `dig [@ip.serv.DNS] nomDNS.` O `drill`

!!!NOTE "NOTA"
    Otro cliente pero sólo compatible con systemd-resolved es `systemd-resolve`


##whois

`whois dominioDNS`

Consulta en los servidores whois publicos (administrados por la IANA) para averiguar el propietario o registrador del dominio

##wget

`wget https://url/un/archivo`

Descarga al disco duro el archivo indicado

-c Continúa la descarga (si anteriormente falló) desde donde se interrumpió

-O nombre Indica el nombre que tendrá el archivo una vez descargado

-r Realiza una descarga recursiva si la URL indicada es la de una carpeta en vez de la de un archivo. Combinado con el parámetro -l nº sirve para indicar hasta qué nivel (1 = una subcarpeta, 2 =dos subcarpetas) se quiere descargar … si no se indica se entiende «infinito»

-N Descarga sólo los archivos más nuevos que los locales

-A «ext1», «ext2», … Descarga sólo los archivos que encuentre con la extensión indicada El parámetro contrario (descarga todo excepto los archivos indicados) es -R

–no-parent No descarga contenido anterior a la URL indicada

-nd Todo lo descarga en la misma carpeta local (sin respetar, pues, la jerarquía de carpetas del sitio remoto)

-k Una vez hecha la descarga, transforma los enlaces para que todo el contenido se pueda visitar offline (cambia las rutas absolutas para relativas y los recursos no descargados los referencia con la URL completa

##curl

`curl https://url/un/archivo`

Descargar el fichero indicado y muestra en pantalla su contenido

-o nombre Descargar archivo indicado y lo guarda en el disco duro con el nombre que se especifique

-O Descargar el fichero indicado y lo guarda en el disco duro con el nombre que tenga el original

-C – Continúa la descarga desde el no de byte indicado (si es un guión, será a partir de donde se paró la descarga -fallida- anterior del mismo archivo

-s Modo «silencioso» (no muestra ni las estadísticas de descarga ni los errores, nada)

-SS Modo «silencioso» pero mostrando los mensajes de error

-v Modo «verboso». Sirve para mostrar las cabeceras de cliente enviadas a la petición

-Y No descarga el archivo: sólo muestra la cabecera de respuesta HTTP del servidor

-y Mostrar en pantalla tanto las cabeceras de respuesta como el contenido del archivo pedido

-D nombre Guarda en el disco duro, en forma de archivo con el nombre indica, las cabeceras de respuesta

-L Si el servidor web devuelve un código de redirección (3xx), lo sigue automáticamente

-H «cabecera: valor» Realiza una petición indicando un valor concreto para la cabecera HTTP de cliente indicada. Se pueden poner múltiples parámetros -H.

–X tipo Realiza una petición del tipo indicado (POST, PUT, etc). Por defecto son GET

[Nomenclatura de tarjetas de red en Linux]:/LPIC1/Networking/#nomenclatura-de-tarjetas-de-red-en-linux

##dig

Averiguar MX de un dominio, comando dig
    
    dig mx sugestionweb.com
     
    ; <<>> DiG 9.10.3-P4-Ubuntu <<>> mx sugestionweb.com
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12971
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
     
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 512
    ;; QUESTION SECTION:
    ;sugestionweb.com.      IN  MX
     
    ;; ANSWER SECTION:
    sugestionweb.com.   14400   IN  MX  10 mx1.spamcluster.com.
    sugestionweb.com.   14400   IN  MX  20 mx2.spamcluster.com.
     
    ;; Query time: 66 msec
    ;; SERVER: 127.0.1.1#53(127.0.1.1)
    ;; WHEN: Thu Jun 07 10:46:19 CEST 2018
    ;; MSG SIZE  rcvd: 97

    
    
## Ver la configuración actual de la red


### Dirección IP

Para ver el estado y configuración de las tarjetas detectadas se puede usar el comando ip address show (o bien ip address show dev NombreTarjeta si sólo se quiere obtener la información de una tarjeta determinada). Concretamente nos muestra:

* Las direcciones MAC de las tarjetas
* Su estado respectivo (UP, DOWN)
* Sus direcciones IP respectivas (y la máscara correspondiente)
* Otros datos (como si permite el envío «broadcast», si está en modo «promiscuo», etc).

!!! Note
    NOTA: El comando ip address show se puede escribir de forma más corta así: ip a s. Incluso, se puede dejar de escribir el verbo show (o s) porque es la acción por defecto (por lo tanto, se puede hacer ip address o ip a y sería lo mismo). También es útil el parámetro -c (así: ip -c a s) para ver los datos más relevantes en colores.


###Puerta de Enlace
Para saber, en cambio, cuál es la puerta de enlace configurada en nuestra máquina, usaremos el comando ip route show (o bien ip route show dev nomTarjeta o sus variantes ip route, ip r s o ip r). Este comando debe mostrar una línea que comenzará con la expresión «default via» seguida de la dirección IP de la puerta de enlace establecida. Este comando puede mostrar más líneas, pero no nos interesarán mucho … (quizás la más curiosa es una que sirve para indicar que no hay ninguna puerta de enlace para comunicarse con las máquinas que precisamente pertenezcan a la misma red a la que pertenece nuestra máquina).

###Servidores DNS

Para saber la dirección IP del servidor DNS configurado en nuestra máquina (o las IPs … si hay más de una se prueba conectar a la primera y si esta falla entonces se prueba la segunda, y así) se puede consultar el archivo /etc/resolv.conf (concretamente, las líneas que comienzan por la palabra nameserver). Estos servidores serán los que todas las aplicaciones del sistema (desde el ping hasta el navegador) utilizarán para averiguar cuál es la IP del nombre que el usuario haya escrito.

El contenido de este archivo suele ser gestionado por diferentes programas (como puede ser el cliente dhclient, la aplicación NetworkManager, el servicio «networking«, el servicio «systemd-networkd/resolved«, etc) y es por ello que no se recomienda modificarlo manualmente ya que los cambios realizados a mano podrían «Machacar» sin avisar en cualquier momento por cualquiera de estos programas.

En este sentido, estos programas (dhclient, NetworkManager, «networking», «systemd-networkd / resolved, etc) guardan los servidores DNS que usan dentro de sus propios archivos de configuración y los manipulan allí de forma autónoma (por ejemplo NetworkManager usa /var/run/NetworkManager/resolv.conf, «systemd-resolved» usa /run/systemd/resolve/resolv.conf, «Networking» usa la línea dns-nameservers dentro de /etc/network/interfaces, etc) pero además siempre vinculan en forma de enlace simbólico su archivo propio respectivo al archivo común /etc/resolv.conf para que los programas que utilicen este archivo común no tengan problemas en encontrar los servidores DNS.

``` Note
NOTA: En ocasiones al consultar el archivo /etc/resolv.conf el único servidor que aparece es el 127.0.1.1 , esto probablemente se deba a que está instalado el demonio dnsmasq que guarda una caché de DNS y de DHCP,. En el caso de querer utilizar otros servidores DNS asignados por otro dispositvo por DHCP (un router por ejemplo) podemos encontrarnos que la máquina no hace caso. Para solucionarlo, modificaremos el archivo /etc/NetworkManager/NetworkManager.conf y comentaremos la linea dns=dnsmasq con una «#» al principio. Después reiniciaremos el servicio Network Manager con sudo service network-manager restart. Si consultamos de nuevo el fichero /etc/resolv.conf veremos que ahora si asigna los DNS correctamente.
```