
https://www.kernel.org/

`ldconfig -v` → regenera la caché de librerias, Para poder ver algo, activamos el verbose a 1, si no no muestra información

`uname` → muestra “Linux” 

`uname -a` → muestra la versión del kernel, arquitectura …

```
Linux debian 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt25-2 (2016-04-08) x86_64 GNU/Linux
```

`uname -r` → solo muestra la versión del kernel
```
3.16.0-4-amd64
```

3 → Release del Kernel (si es par es stable, si es impar es unstable)

16 → Major Version

0-4 → Revision y patch

amd64 → arquitectura


echo “estoy usando kernel: `uname -r`”


`lsmod` → muestra los módulos del kernel cargados ahora mismo.

## Breve introducción a la gestión de módulos del kernel

Los módulos del kernel son archivos con extensión ".ko" (de "kernel object") y se encuentran en la carpeta `/lib/modules/$(uname -r)`. Para añadir su funcionalidad particular a la que proporciona el propio kernel por
defecto, hay que cargarlos en memoria. Como veremos enseguida, esto se puede hacer de dos maneras: de forma temporal (hasta que se reinicie la máquina) o bien de forma permanente. A continuación se listan algunas de los
comandos que pueden ayudar a la gestión de los módulos:

## Información de módulos
- `lsmod`: muestra la lista de los módulos actualmente cargados, su tamaño (en bytes), y el número y nombre de otros módulos que utilizan el módulo en cuestión como dependencia necesaria para ellos poder funcionar correctamente.

- `modinfo` nomModul: muestra información sobre el módulo indicado (ruta, descripción, licencia, autor, dependencias, ... y sobre todo, la lista de parámetros que puede admitir). Esta información se puede filtrar con diferentes parámetros; por ejemplo, `modinfo -p nomModul` sólo muestra los parámetros que puede admitir, `modinfo -n nomModul` sólo muestra la ruta, etc. 

Otra herramienta que se puede utilizar para obtener información sobre un determinado módulo (incluida en el paquete "sysfsutils") es `SysTools -v -m
mac80211_hwsim` (donde, por ejemplo, mac80211_hwsim es un módulo que permite simular tarjetas wifi)

##Cargar y descargar módulos

`modprobe nomModul [param1 = valor1]` [param1 = valor1] [...]: Carga de forma temporal el módulo indicado. Opcionalmente se puede indicar una lista de parámetros con el valor que queramos asignar a cada uno de ellos. Por ejemplo, en el caso de querer simular cuatro tarjetas wifi, habrá cargar el módulo mac80211_hwsim así: `modprobe mac80211_hwsim radios = 4` 

`modprobe -r nomModul` (o también rmmod nomModul): Descargar el módulo indicado.

!!!NOTE "Nota:"
    En el caso de que el módulo estuviera integrado dentro del kernel (es decir, que no hubiera que cargarlo explícitamente con modprobe porque ya viene cargado "de serie") pero quisiéramos alterar el / los valor / es de alguno de sus parámetros por defecto, el truco sería añadir esta lista de parámetros (con la sintaxis nomModul.param1 = valor1 nomModul.param2 = valor2, etc) a la "kernel command line", manipulable dentro de la configuración del gestor de arranque usado. Por ejemplo, en caso del Grub, esta lista habría que escribirla en la línea GRUB_CMDLINE_LINUX del archivo `/etc/default/grub`.

!!!NOTE "Nota:"
    Gracias a la información obtenida por la herramienta depmod, modprobe carga automáticamente además todos los módulos que sean dependencias del indicado (cosa que, por ejemplo, el coomando `insmod nomModul`, que también sirve para cargar módulos de forma temporal, no hace).

En general, la carga de módulos se hace automáticamente cuando es necesario (por ejemplo, cuando se introduce un dispositivo USB, para acceder a su sistema de ficheros) gracias al componente del sistema llamado Udev. No obstante, en algún caso conviene establecer "a mano" la carga de un módulo de forma permanente. Esto se hace modificando dos archivos:

-  `/etc/modules-load.d/nomModul.conf`: debe contener una sola línea consistente sólo en el nombre del módulo. Por ejemplo, si queremos cargar de forma permanente el módulo "mac80211_hwsim" hay que crear un archivo llamado `/etc/modules-load.d/mac80211_hwsim.conf` con la línea: `mac80211_hwsim`

-  `/etc/modprobe.d/nomModul.conf`: debe contener una lista de los parámetros (cada uno en una línea diferente) que se aplicarán a la carga del módulo indicado. Cada línea de este archivo debe tener la siguiente sintaxis: *options nomModul paramX = valorX*. Por ejemplo, si queremos que el módulo `Mac80211_hwsim` se cargue simulando 4 tarjetas WiFi, hay que crear un archivo llamado `/etc/modprobe.d/mac80211_hwsim.conf` con la línea: `options mac80211_hwsim radios = 4`. 
  
##Alias
Otra cosa que podemos hacer con los módulos es crear alias (es decir, nombres alternativos) de manera que podamos indicar estos nombres alternativos (generalmente más cortos y / o fáciles de recordar) a la hora de ejecutar los comandos modprobe y similares. Esto se hace creando un archivo (por cada alias):

- `/etc/modprobe.d/nomAlias.conf`: debe contener una línea con la siguiente sintaxis: `alias nomAlias nomModul`, donde "nomAlias" admite comodines para permitir diferentes alias alternativos por el mismo nomModul. Así, si quisiéramos llamar "wifiQUALSEVOLCOSA" al módulo mac80211_hwsim, habría que crear un archivo llamado `/etc/modprobe.d/wifi.conf` que contenga la siguiente línea: 

    ```alias wifi * mac80211_hwsim
    ```

##Bloquear módulos
Finalmente, otra cosa que se puede hacer con los módulos es bloquearlos para impedir su carga. Esto puede ser útil si, por ejemplo, sabemos que el hardware asociado no se necesita o si la carga del módulos da problemas. Esto se hace creando un archivo (único para todos los módulos a bloquear) que se puede
llamar como queramos pero que en general se suele llamar `blacklist.conf`:
`/etc/modprobe.d/blacklist.conf`: debe contener una lista de los nombres de los módulos a bloquear (Cada uno en una línea diferente). Cada línea de este archivo debe tener la siguiente sintaxis: *blacklist nomModul* Por ejemplo, si queremos bloquear el módulo "mac80211_hwsim", hay que crear (o o editar si ya
existe) el archivo `/etc/modprobe.d/blacklist.conf` y hacer que contenga la línea:
```
blacklist mac80211_hwsim
```

!!!NOTE "Nota:"
    The blacklist command will blacklist a module so that it will not be loaded automatically, but the module may be loaded if another non-blacklisted module depends on it or if it is loaded manually.However, there is a workaround for this behaviour; the install command instructs modprobe to run a custom command instead of inserting the module in the kernel as normal, so you can force the module to always fail loading with this line in /etc/modprobe.d/blacklist.conf : install module_name /bin/false This will effectively blacklist that module and any other that depends on it.

!!!NOTE "Nota:"
    You can also blacklist modules from the bootloader. This can be very useful if a broken module makes it impossible to boot your system. Simply add modprobe.blacklist=modname1,modname2,modname3 to your bootloader's kernel line.


Para más información, consultar `man modprobe.d`