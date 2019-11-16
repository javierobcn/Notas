# Systemd (I)

##Introducción

Systemd es varias cosas:

- El proceso Init (PID 1) del sistema
- El gestor de demonios
- Un intermediario entre aplicaciones de usuario y ciertas partes de la API del kernel de Linux

La configuración general de systemd se encuentra en el archivo `/etc/systemd/system.conf`; muchos valores por defecto están allí establecidos.

Para saber la versión actual de systemd que hay funcionando el sistema, hacer `systemctl --version`

##"Units": tipos y ubicación

Todo lo que es gestionado por systemd se llama "unit" y cada "unit" es descrita por un archivo de configuración propio, el cual tendrá una extensión diferente según el tipo de de unidad que se trate:

- **.service**: Describe la configuración de un demonio
- **.socket**: Describe la configuración de un socket (de tipo UNIX o TCP / IP) asociado a un .service
- **.device**: Describe un dispositivo hardware reconocido por el kernel (vía udev o sysfs) gestionado por systemd
- **.mount**: Describe un punto de montaje gestionado por systemd
- **.automount**: Describe un punto de automontaje asociado a un .mount
- **.swap**: Describe una partición o archivo de intercambio gestionado por systemd
- **.target**: Define un grupo de Units (se utiliza a modo de "metapaquete" de Units)
- **.path**: Describe una carpeta o archivo monitorizado por la API Inotify del kernel
- **.timer**: Describe la temporización / activación de una tarea programada (usando el programador systemd)
- **.slice**: Define un grupo de Units asociadas a procesos para administrar y limitar los recursos comunes (CPU, memoria, discos, red). Usa internamente los llamados "cgroups" del kernel

Los archivos de configuración de las Units (sean del tipo que sean) pueden estar repartidos en tres carpetas distintas:

- `/usr/lib/systemd/system`: Para Units proporcionadas por los paquetes instalados en el sistema
- `/run/systemd/system`: Para Units generadas en tiempo real durante la ejecución del sistema. no persistentes
- `/etc/systemd/system`: Para Units proporcionadas por el administrador del sistema

Los archivos en `/etc/...` **sobreescriben** los archivos **homónimos** que estén en `/run/...` los cuales sobreescriben los que estén en `/usr/lib/...` (o en algunas distribuciones, `/lib/...`). Si no tienen el mismo nombre, todos los archivos de las tres carpetas se mezclan ordenados por su nombre de forma numericoalfabètica y se van leyendo en este orden hasta el final.

Por otra parte, si dentro de `/usr/lib/...`, `/run/...` o `/etc/...` hay una carpeta llamada como una unit seguido del sufijo ".d", cualquier archivo con extensión * .conf que haya en su interior será leído justo después de los ficheros de configuración de la unit pertinente. Esto sirve para poder añadir (o sobreescribir) opciones de configuración concretas (las presentes en estos archivos) sin tener que tocar las configuraciones "genéricas" de la unit. por
ejemplo: el archivo `/usr/lib/systemd/system/beep.service.d/foo.conf` puede ser útil para modificar la configuración definida en `/usr/lib/systemd/systemd/beep.service` (y de este modo, hacer posible que un paquete pueda cambiar la configuración establecida por otro) y el archivo `/etc/systemd/system/beep.service.d/foo.conf` puede ser útil para modificar la configuración definida en `/usr/lib/systemd/system/beep.service` (y de este modo, hacer
posible que un administrador pueda cambiar ciertas partes de la configuración de la unit preempaquetada al sistema sin tener que reemplazar completamente). Estos archivos "override" (concretamente con el nombre `/etc/systemd/system/nomUnit.d/override.conf`) se pueden generar de una manera muy cómoda y rápida con la orden `systemctl edit nomUnit`

Algunas "units" contienen un símbolo @ en su nombre (por ejemplo, nom@cadena.service); esto significa que son instancias de una unit-plantilla, el archivo de configuración de la cual es el que no contiene la parte
"Cadena" en su nombre (así: nombre @.service). La parte "cadena" es el identificador de la instancia (de hecho, dentro del archivo de configuración de la unit-plantilla el valor "cadena" sustituye todas las ocurrencias del especificador especial %i).

##Comandos para gestionar Units (principalmente de tipo "service")

A continuación mostramos algunos de los comandos más importantes para gestionar Units principalmente (No exclusivamente) de tipo "service":

`systemctl [list-Units] [-t {service | socket | ...}] [--all | --failed | --state = inactive]` Muestra el estado de las Units que están "activas" (del tipo indicado, si no se indica, aparecen todas).

- Si se escribe --state = inactive se muestra el estado de las Units que están "inactivas"
- Como valor del parámetro `--state` también se puede poner cualquier valor válido de la columna SUB
- Si se escribe `--failed` se muestra el estado de todas las Units con errores
- Si se escribe --all se muestra el estado de todas las Units ( "activas", "inactivas", con errores y otros)
-La diferencia entre las columnas LOAD, ACTIVE y SUB la dice la salida de la propia comando:

    - **LOAD** = Indica si la Unit ha sido cargada en RAM. Posibles valores: "loaded", "error", "Masked"

    - **ACTIVE** = Estado genérico de la unit. Posibles valores: "active", "inactive", "failed", "(des) activating"

    - **SUB** = Estado más concreto de la unit, depende del tipo de unit, posibles valores "plugged", "mounted", "running", "exited", "waiting", "listening", etc

`systemctl [-t {service | socket | ...}] list-unit-files`

El comando `list-units` sólo muestra las units que systemd ha intentado leer y cargar en memoria. Ya que systemd sólo lee las units que él piensa que necesita, así no incluye necesariamente todas las units disponibles en el  sistema. Para ver todas las units, incluyendo aquellas que systemd no ha intentando ni siquiera cargar, hay que utilizar `list-unit-files`. Este subcomando muestra el "estado de carga" de cada unit y sus posibles valores son:

- **"enabled"** o **"enabled-runtime"** : La unit se activará en el siguiente reinicio -y subsiguientes-.

    !!!NOTE "NOTA"
        Esto se consigue gracias a la existencia de un enlace al archivo de configuración de la unit en cuestión dentro de la carpeta `/etc/systemd/system/nomTarget.target.wants`, creado en algún momento previo con el comando systemctl enable (ver más abajo) o de forma manual con ln -s

- **"static"**: La unit no tiene sección "[Install]" en su archivo de configuración. Esto hace que los comandos `systemctl enable` (y sobre todo `systemctl disable`) no funcionen. Por tanto, el hecho de que la unit esté
activada o no en un determinado "target" dependerá de la existencia "estática" de su enlace correspondiente dentro de la carpeta `/etc/systemd/system/nomTarget.target.wants`. Este tipo de units suelen estar asociadas a las que realizan una acción "oneshot" o bien a las que son usadas sólo como
dependencia de alguna otra unit (y por tanto no deben ejecutarse por sí mismas)

- **"generated"**: La unit se activará mediante un mecanismo automático especial llamado "generator", ejecutado al arrancar el sistema. Cada unit en este estado tiene su propio "generator".

- **"transient"** : La unit es temporal y no sobrevivirá al siguiente reinicio

- **"disabled"**: La unit está desactivada y, por tanto, no se pondrá en marcha en los siguientes reinicios (gracias a la inexistencia del enlace correspondiente dentro de `/etc/systemd/system/nomTarget.target.wants`).
Tampoco podrá ser iniciada automáticamente mediante otros sistemas (como vía socket, vía D-Bus o bien vía conexión de hardware. No obstante, podrá ser puesta en marcha en cualquier momento "manualmente" ejecutando `systemctl start`( ver más abajo)

- **"Masked"** o **"Masked-runtime"**: La unit está Enmascarada (es decir, está desactivada y, por tanto, no se pondrá en marcha en los siguientes reinicios ni automáticamente, pero además, tampoco podrá ser puesta nunca
en marcha manualmente con systemctl start ni siquiera si es una dependencia de otro servicio)

`systemctl {start | stop | restart} nomUnit[.service]` Activa / Desactiva / Reiniciar la unit indicada inmediatamente siguiendo las indicaciones escritas en su archivo de configuración correspondiente.

!!!NOTE "NOTA"
    Si la unit no fuera de tipo ".service", entonces habrá que indicar su tipo explícitamente última su nombre (por ejemplo, `systemctl start nomUnit.socket`). Esta norma es extensiva para el resto de comandos 

`systemctl {enable | disable} nomUnit[.service]` Activará / desactivará automáticamente la unit indicada a partir del siguiente reinicio (y siguientes)

!!!NOTE "NOTA"
    En realidad lo que hace enable / disable es crear / eliminar un enlace dentro de la carpeta `/etc/systemd/systemd/nomTarget.target.wants` al archivo de configuración de la unit en cuestión (donde "nomTarget" viene definido en la directiva WantedBy de la sección "[Install]" de dicho archivo).

`systemctl {mask | unmask} nomUnit [.service]` Enmascara / desenmascarar la unit indicada.

!!!NOTE "NOTA"
    Esto lo consigue vinculando el archivo de configuración ubicado en `/etc/...` de la unit en cuestión a /dev/null

`systemctl is-enabled nomUnit[.service]` Devuelve `$? = 0` si la unit indicada está configurada para activarse en los siguientes reinicios (es decir, si está en los estados listados para `systemctl list-unit-files` : "enabled", "enabled-runtime", "static", "Generated" o "transient") y además, muestra en pantalla este estado.

`systemctl is-active nomUnit [.service]` Devuelve $? = 0 si la unit indicada está activa y, además, muestra en pantalla este estado (valor listado en la columna ACTIVE de systemctl list-units)

`systemctl is-failed nomUnit[.service]` Devuelve $? = 0 si la unit indicada falló al intentar activarse y, además, muestra en pantalla este estado. Si no queremos que se muestren los estados en pantalla (esto también por is-enabled y is-active ), se puede añadir el parámetro -q

!!!NOTE "NOTA"
    Una unit puede estar en estado "failed" por múltiples razones: porque el proceso ha terminado con un código de error diferente de 0, porque ha finalizado de forma anormal, porque se ha superado un timeout determinado, etc.

`systemctl status {nomUnit [.service] | PID}` Muestra el estado e información variada sobre la Unit o proceso indicado. Si se indica una unit se puede ver ...:
```BASH
    Loaded: loaded (/usr/lib/systemd/system/cups.service; enabled; vendor preset: disabled)
    Active: active (running) since Sat 2017-11-18 20:48:06 CET; 4h 2min agosto
    Docs: man: cupsd (8)
    Main PID : 745 (cupsd)
    Status: "Scheduler is running ..."
    Tasks: 1 (límite: 4915)
    CGroup: /system.slice/cups.service
    └─745 / usr / sbin / cupsd -l

    Últimas líneas de journald -u (se puede usar los parámetros homónimos -n nº y -o xxx)
```

Los valores para la línea "Loaded:" son los mismos que aparecen en la columna LOAD de list-units

Seguidamente se indican los valores del estado actual y el predefinido por paquete, que serán uno de los detallados anteriormente al hablar de list-unit-files

Los valores para la línea "Active:" son los mismos que aparecen en la columna ACTIVE de list-Units

El punto ( "●") es blanco si la unit está "inactive"; rojo si "failed" o verde si "active"

Si se indica un PID en vez de una unit, se puede ver la misma información, pero esta manera puede ser útil para conocer la unit a la que está asociado un determinado proceso, por ejemplo (aunque para conocer esta información también se podrían observar los valores de la columna "unit" mostrada para el comando `ps -o` si así se indica con el parámetro -o ):

```BASH
cups.service - CUPS Scheduler
Loaded: loaded ( /usr/lib/systemd/system/cups.service ; enabled; vendor preset:
Active: active (running) since Sat 2017-11-18 20:48:06 CET; 4h 2min agosto
Docs: man: cupsd (8)
Main PID: 745 (cupsd)
Status: "Scheduler is running ..."
Tasks: 1 (límite: 4915)
CGroup: /system.slice/cups.service
└─745 / usr / sbin / cupsd -l
Últimas líneas de journald _PID = (se puede usar los parámetros homónimos -n nº y -o xxx)
```

`systemctl show {nomUnit [.service] | PID}` Muestra la configuración actual de la Unit (obtenida a partir del archivo general system.conf y del archivo de configuración propio de la unit) indicada en un formato adecuado para ser procesado por máquinas. con el parámetro `-p "nomClave, OtroNombre,...` se pueden obtener sólo las parejas clave <-> valor deseadas.

`systemctl daemon-reload` Actualizar todos los archivos de configuración de Units nuevas o modificadas desde la última vez que se puso en marcha systemd (incluyendo los generators).

`systemctl help nomUnit [.service]` Abre la página man asociada a la Unit indicada (en su fichero de configuración debe venir indicada)

`systemctl edit nomUnit [.service]` Crea (con el editor de texto predeterminado del sistema) un fichero de configuración (inicialmente vacío) para la Unit indicada llamado `/etc/systemd/system/nomUnit.tipusUnit.d/override.conf` para sobrescribir (o ampliar) la configuración ya existente por ella. Una vez guardados los cambios, recarga la Unit automáticamente con esta nueva configuración. Si se quisiera editar directamente el archivo `/etc/systemd/system/nomUnit.tipoUnit`, hay que añadir entonces el parámetro `--full`

`systemctl cat nomUnit [.service]` Muestra la configuración final actual resultante de haber leído los diferentes ficheros de configuración
posibles de la Unit indicada

`systemd-delta` Muestra qué archivos de configuración de Units están sobreescritos o ampliados (de /usr /lib a /etc y / o con
archivos "overrides"), enmascarados, redireccionados (con la línea Alias ​​= de la sección [Install]), etc y por cuáles

`systemctl kill [--signal = nº] nomUnit [.service]` Envía una señal concreta (indicada con el parámetro --signal ; por defecto es la nº15, SIGTERM) a
todos los procesos asociados a la Unit indicada.

!!!NOTE "NOTA"
    kill  goes directly and sends a signal to every process in the group, however  stop  goes through the  official configured way to shut down a service, i.e. invokes the stop command configured with ExecStop= in the service file. Usually stop should be sufficient. kill is the tougher version, for cases where you either don't want the official shutdown command of a service to run, or when the service is hosed and hung in other ways.

## Servicios Systemd por Usuario
Systemd también permite definir servicios para que no estén asociados al sistema global sino que únicamente formen parte de la sesión de un usuario estándar, generándose una instancia particular del servicio para cada usuario
activo en la máquina. De este modo, cada instancia se iniciará automáticamente después de iniciar la sesión de un usuario y se parará al salir.

!!!NOTE "NOTA"
    Esto es posible gracias a que justo después del primer inicio de sesión que se realice al sistema se pone en marcha (gracias al módulo PAM "pam_systemd") el comando `systemd -user`  ( que es quien permitirá este funcionamiento individual para todas las sesiones de usuarios que se inicien a partir de entonces), además del proceso con PID 1 propiamente dicho, que es `systemd -system` . El proceso `systemd -user` finalizará automáticamente justo después de haberse cerrado el último inicio de sesión existente al sistema.

Los ficheros de configuración de las Units "de tipo usuario" se encuentran en otras carpetas separadas de las de las Units "de sistema". Concretamente (se muestran en orden de precedencia ascendente):

- "/Usr/lib/systemd/user": Para Units proporcionados por los paquetes instalados en el sistema
- "~ / .Local / share / systemd / user": Para Units de paquetes que han sido instaladas en la carpeta personal
- "/ Etc / systemd / user": Para Units proporcionados por administrador del sistema
- "~ / .Config / systemd / user": Para Units construidas por el propio usuario

!!!NOTE "NOTA"
    La variable especial **%h** se puede utilizar dentro de los archivos de configuración de las Units "de usuario" para indicar la ruta de la carpeta personal del usuario en cuestión.

Otra característica de las Units "de usuario" es que pueden ser gestionadas por parte de este usuario sin que deba ser administrador del sistema; esto lo puede hacer con las mismas órdenes `systemctl...`  ya conocidas sólo que añadiendo el parámetro --user Así, por ejemplo, para arrancar un servicio automáticamente cada vez que se inicie nuestra sesión habrá que ejecutar `systemctl --user enable nomUnit` ; para ver el estado de
todas nuestras Units "de usuario" habrá que hacer `systemctl --user list-units` ; para recargar las Units modificadas habrá que hacer `systemctl --user daemon-reload` , etc

##Secciones y directivas comunes en los ficheros de configuración de las Units
La estructura interna de los archivos de configuración de las Units está organizada en secciones, distinguidas cada una por un encabezamiento sensible a mayúsculas y minúsculas rodeado de corchetes ( [Encabezamiento] ). Dentro de las secciones se definen diferentes directivas (también mayúsculas y minúsculas) en la forma de parejas NomDirectiva = valor , donde el valor puede ser una palabra, una frase, una ruta, un número, true/yes, false/no, una
fecha, etc, dependiendo de su significado.

!!!NOTE "NOTA"
    NOTA: También pueden existir directivas donde no se escriba ningún valor (es decir, así: NomDirectiva = ). En este caso, se estará "Reseteando" (es decir, anulando) el valor que previamente se hubiera dado en otro sitio

La primera sección (aunque el orden no importa) siempre suele ser la llamada [Unit] y se utiliza para definir datos sobre la propia Unit en sí como Unit que es y la relación que tiene ésta con otros Units. algunas de sus directivas más habituales son:

- **Description** = Una breve descripción de la Unit
    
    Su valor es devuelto por diferente herramientas systemd

- **Documentation** = man: sshd (8) https: //ruta/pag.html
    

    Proporciona una lista de URIS que apuntan a documentación de la Unit.

    El comando `systemctl status` las muestra

- **Wants** = unservei.service unaltre.service untarget.target ...
    
    Lista las Units que deberían estar iniciadas para que el Unit en cuestión pueda funcionar correctamente. Si no lo están ya, systemd las iniciará en paralelo junto con el Unit en cuestión; si se quiere indicar un cierto orden en vez de iniciar todas en paralelo, se puede utilizar las directivas After = o Before =. Si alguna de las Units listadas falla al iniciarse, el Unit en cuestión se iniciará igualmente

- **Requires** = unservei.service unaltre.service untarget.target ...

    Lista las Units que imprescindiblemente deben estar iniciadas para que el Unit en cuestión pueda funcionar correctamente. Si no lo están ya, systemd las iniciará en paralelo junto con el Unit en cuestión; si se quiere indicar un cierto orden en vez de iniciar todas en paralelo, se puede utilizar las directivas After = o Before =. Si alguna de las Units listadas falla al iniciarse, el Unit en cuestión también fallará automáticamente


- **BindsTo** = unservei.service unaltre.service untarget.target ...
    Similar a Requires = pero, además, hace que el Unit en cuestión se detenga automáticamente si alguna de las Units asociadas finaliza.

- **Before** = unservei.service unaltre.service untarget.target ...
    Indica, de las Units listadas en las directivas Wants = o Requires =, qué no se iniciarán en paralelo sino tras la Unit en cuestión. Si aquí se indicara alguna Unit que no se encontrara listada en Wants = o Requires =, esta directiva no se tendrá en cuenta.

- **After** = unservei.service unaltre.service untarget.target ...
    Indica, de las Units listadas en las directivas Wants = o Requires =, qué no se iniciarán en paralelo sino antes de la Unit en cuestión. Si aquí se indicara alguna Unit que no se encontrara listada en Wants = o Requires =, esta directiva no se tendrá en cuenta.

!!!NOTE "NOTA"
    Lo más típico es tener una Unit A que necesita que la Unit B esté funcionando previamente para poderse poner en marcha. En este caso, simplemente habría que añadir las líneas Requires = B y After = B en la sección [Unido] del Unit A. Si la dependencia es opcional, se puede sustituir Requires = B para Wants = B

- **Conflicts** = unservei.service unaltre.service ...
    Lista las Units que no pueden estar funcionando a la vez que el Unit en cuestión. iniciar una Unit con esta directiva causará que las aquí listadas se detengan automáticamente.

- **ConditionXXXX** = ...
    Hay un conjunto de directivas que empiezan por "Condition" que permiten al administrador comprobar ciertas condiciones antes de iniciar el Unit. Si la condición no se cumple, la Unit es ignorada. Algunos ejemplos son:

        ConditionKernelCommandLine = param [= valor]
        ConditionACPower = {yes | no}
        ConditionPathExists = [!] / Ruta / archivo / o / carpeta
        ConditionPathExistsGlob = [!] / Ruta / archivos / o / carpetas
        ConditionPathIsDirectory = [!] / Ruta / carpeta
        ConditionPathIsSymbolicLink = [!] / Ruta / enlace
        ConditionPathIsMountPoint = [!] / Ruta / carpeta
        ConditionPathIsReadWrite = [!] / Ruta / archivo / o / carpeta
        ConditionDirectoryNotEmpty = [!] / Ruta / carpeta
        ConditionFileNotEmpty = [!] / Ruta / archivo
        ConditionFileIsExecutable = [!] / Ruta / archivo
        AssertXXXX = ...

Al igual que con "ConditionXXX", hay un conjunto de directivas que empiezan por "Assert" que permiten al administrador comprobar ciertas condiciones antes de iniciar el Unit. la diferencia es que aquí, si la condición no se cumple, se emite un error.

- **.OnFailure** = unaunit.service otro.service ...
    Indica las Units que se activarán cuando la Unit en cuestión entre en estado "failed". esta directiva puede utilizarse, por ejemplo, para ejecutar una Unit que envíe un correo electrónico cuando la Unit en cuestión, que podrá ser un servicio, falle.


- **AllowIsolate** = yes
    Esta directiva sólo tiene sentido para Units de tipo target. Si su valor es "yes" (por defecto es "no") indica que el target en cuestión admitirá que se le aplique el comando systemctl Isolate (ver más abajo)

Por otra parte, la última sección (aunque el orden no importa) de un archivo de configuración de una Unit siempre suele ser la llamada [**Install**] , la cual, atención, es opcional. Se utiliza para definir cómo y cuando la Unit puede
ser activada o desactivada. Algunas de sus directivas más habituales son:

- **WantedBy** = untarget.target unaltre.target ...
    
    Indica los targets donde el Unit en cuestión se activará al ejecutar el comando `systemctl enable` Cuando se ejecuta este comando, lo que pasa es que por cada target indicado aquí aparecerá,dentro de cada carpeta `/etc/systemd/system/nomTarget.wants` respectiva, un enlace simbólico apuntando al propio archivo de configuración del Unit en cuestión. La existencia de este enlace es el que realmente activa de forma efectiva un servicio automáticamente. Eliminar los links de todas las carpetas "nomTarget.wants" pertinentes implica desactivar la Unit (que es lo que hace, de hecho,el comando `systemctl disable` a partir de la lista de targets que encuentra en la línea WantedBy = ).

    Por ejemplo, si el archivo de configuración de la Unit en cuestión (que llamaremos pepito.service) tiene una línea como WantedBy = multi-user.target, al ejecutar `systemctl enable pepito.service` aparecerá dentro de la carpeta `/etc/systemd/system/multi-user.wants` un link apuntando a este archivo de configuración

- **RequiredBy** = untarget.target unaltre.target ...

    Similar a WantedBy = pero donde el fallo del Unit en cuestión en ejecutar systemctl enable hará que los targets indicados aquí no puedan llegar a alcanzar. La carpeta donde se encuentra el link de el Unit en este caso se denomina `/etc/systemd/system/nomTarget.requires`

- **Alias** ​​= unaltrenom.tipusUnit
    
    Permite al Unit en cuestión ser activada con `systemctl enable` utilizando otro nombre diferente

- **Also** = unservei.service unaltre.service ...

    Permite activar o desactivar diferentes Units como conjunto. La lista debe consistir en todas las Units que también se quieren tener habilitadas cuando la Unit en cuestión esté habilitada

###Sección [Service] (por Units de tipo .service):

Dependiendo del tipo de Unit que tengamos nos podremos encontrar con diferentes secciones específicas dentro de su fichero de configuración, normalmente escritas entre la sección [Unit] el principio y la sección [Install] del final (si existe). En el caso de las Units de tipo "service", por ejemplo, nos encontramos con la sección específica llamada [Service] , la cual puede incluir diferentes directivas como las siguientes:

!!!NOTE "NOTA"
    Las Units de tipo device, snapshot y target no tienen secciones específicas

- **Type** = maneraDarrancar 
 
    Existen diferentes métodos para iniciar un servicio, y el método elegido, el cual dependerá del tipo de ejecutable a poner en marcha, se indicará en esta directiva. Las posibilidades más comunes son:

    - **simple**: El servicio nativamente se queda en primer plano de forma indefinida y es systemd quien lo pone en segundo plano (le crea un fichero PID, lo para cuando sea necesario, etc). Systemd interpreta que el servicio está listo luego que el ejecutable asociado se pone en marcha (aunque esto sea demasiado pronto para que no esté listo todavía para recibir peticiones)
    
    - **forking**: El servicio nativamente ya se pone en segundo plano. Systemd interpreta que el servicio está listo cuando pasa efectivamente a segundo plano. En este caso conviene indicar también la directiva PidFile=/ruta/fitxer.pid para que systemd tenga un control sobre qué proceso es el que está en segundo plano y lo pueda identificar
    
    - **oneshot**: Útil para scripts, que se ejecutan (haciendo `systemctl start` igualmente) una vez y finalizan.Systemd esperará hasta que el proceso finalice e interpreta que está listo cuando haya finalizado.
    Se puede considerar el uso de la directiva RemainAfterExit = yes para "engañar" a systemd diciéndole que el servicio continúa activo aunque el proceso haya finalizado; en este caso, la directiva ExecStop = no se llegará a hacer efectiva nunca. 

    También están las posibilidades "dbus" (similar a "simple" pero systemd interpreta que está listo cuando el nombre indicado en BusName = ha sido adquirido), "idle" (similar a "simple" pero con la ejecución retrasada hasta que no se ejecute nada más; se puede utilizar este método, por ejemplo, para emitir un sonido justo después de la finalización del arranque del sistema.) y "notify" (El sistema más completo, donde se establece un canal de comunicación interno entre el servicio y Systemd para notificarse estados y eventos vía la API propia de systemd sd_notify () y donde Systemd interpreta que está listo cuando recibe el estado correspondiente a través de este canal; si queremos que scripts utilicen este método hay que usar el comando systemd-notify )

- **ExecStart** = /ruta/ejecutable param1 param2 ...
    Indica el comando (y parámetros) a ejecutar cuando se realiza un `systemctl start` Si la ruta de el ejecutable comienza con un guión ( "-"), valores de retorno del comando diferentes de 0 (que normalmente se considerarían señal de error) se considerarán como válidos.

    !!!NOTE "Nota"
        Podemos utilizar incluso la directiva SuccessExitStatus = para indicar qué valor consideramos como salida exitosa del programa
    
    !!!NOTE "Nota"
        No habría que escribir la ruta absoluta del ejecutable si ésta se encuentra en la lista de rutas que muestra el comando `systemd-path` , pero en general se recomienda escribirla para evitar sorpresas
    
    !!!NOTE "Nota"
        No se permiten escribir redireccionador ( ">", ">>", "<". "|") Ni el símbolo "&" para pasar a segundo plano

- **ExecStartPre** = /ruta/ejecutable param1 param2 ...
    Indica el comando (y parámetros) a ejecutar antes de lo indicado en ExecStart. pueden haber más de una línea ExecStartPre en el mismo archivo, ejecutándose entonces cada una por orden. la ruta del ejecutable también puede ir precedida de un guión ( "-"), con el mismo significado

- **ExecStartPost** = / ruta / ejecutable param1 param2 ...
    Indica el comando (y parámetros) a ejecutar después de la indicada en ExecStart. pueden haber más de una línea ExecStartPost en el mismo archivo, ejecutándose entonces cada por orden. un ejemplo de posible uso: 
    el envío de un correo justo después de haberse puesto en marcha el servicio correspondiente.La ruta del ejecutable también puede ir precedida de un guión ( "-"), con el mismo significado

- **ExecStop** = /ruta/ejecutable param1 param2 ...
    Indica el comando (y parámetros) a ejecutar cuando se realiza un `systemctl stop` Hay que tener en cuenta que en el caso de un servicio de tipo "oneshot", si no se especifica la directiva RemainAfterExit = yes , el comando indicada en ExecStop se ejecutará automáticamente justo tras ExecStart.

- **ExecStopPost** = / ruta / ejecutable param1 param2 ...
    Indica el comando (y parámetros) a ejecutar después de lo indicado en ExecStop. pueden haber más de una línea ExecStartPost al mismo archivo, ejecutándose entonces cada por orden.

- **Restart** = {always | no | on-success | on-failure | ...}
    Indica las circunstancias bajo las que systemd intentará reiniciar automáticamente un servicio que haya finalizado. En concreto, el valor "always" indica que en cualquier tipo de finalización se volverá a intentar reiniciar; el valor "no" indica que en ningún finalización intentará reiniciar, el valor "on-success" indica que sólo se intentará reiniciar si la finalización ha sido correcta y "on-failure" si la finalización no lo ha sido debido a cualquier tipo de fallo (ya sea que se ha sobrepasado el tiempo de espera del arranque o el apagado, que se ha devuelto un valor diferente de 0, etc)

    !!!NOTE "Nota"
        Se podría dar el caso de que un servicio estuviera reiniciándose todo el rato. Con StartLimitBurts = se puede configurar el número máximo de veces que se quiere que se reinicie y con StartLimitIntervalSec = se puede configurar el tiempo durante el cual se contará este número máximo de veces. Si se llega a este número dentro de este tiempo, el servicio no se volverá a reiniciar automáticamente y tampoco se podrá iniciar manualmente hasta pasado el tiempo indicado (momento en el que se vuelve a contar). También existe la directiva StartLimitAction = , que sirve para indicar la acción a realizar cuando se alcanza el número máximo de reinicios; su valor por defecto es "None" pero puede valer también "reboot" (reinicio limpio), "reboot-force" (reinicio abrupto) y "reboot-immediate" (reinicio muy abrupto)

- **RestartSec** = nºs
    Indica el número de segundos que systemd esperará al reiniciar el servicio después de que haya detenido (si así lo marca la directiva Restart =).

- **TimeoutSec** = nº
    Indica el número de segundos que systemd esperará a que el servicio en cuestión inicie o detenga antes de marcarlo como "failed" (y reiniciarlo si fuera el caso debido a la configuración de la directiva Restart =). Se puede indicar específicamente un tiempo de espera sólo para el inicio con la directiva TimeoutStartSec = y otro tiempo de espera diferente por el apagón con la directiva TimeoutStopSec = . Si no se especifica nada, se toma el valor por defecto (5 min) que está indicado en /etc/systemd/system.conf

- **RemainAfterExit** = yes
    Tal como ya lo hemos comentado, esta directiva se utiliza en servicios de tipo "oneshot" para que la directiva ExecStop = no se ejecute al terminar la ejecución del comando sino al hacer systemctl stop

- **PidFile** = /ruta/fitxer.pid
    Tal como ya lo hemos comentado, esta directiva se utiliza en servicios de tipo "forking" para señalar a systemd cuál será el archivo PID utilizado por el servicio de manera que pueda controlar más fácilmente.

- **User** = unusuari
- **Group** = ungrup
    Set the user or group that the processes are executed as, respectively. They can take a single user/group name, or a numeric ID as argument. For system services (services run by the system service manager, i.e. managed by PID 1) the default is "root". For user services of any other user, switching user identity is not permitted, hence the only valid setting is the same user the user's service manager is running as. If no group is set, the default group of the user is used.

- **WorkingDirectory** = / ruta / carpeta
    Indica el directorio de trabajo del servicio en cuestión. Si no se especifica esta directiva, el valor por defecto es "/" (en el caso de servicios de sistema) o $ HOME (en el caso de servicios de usuario, es decir, iniciados con --user -). Si la ruta se precede con un símbolo "-", el hecho de que la carpeta correspondiente no exista no se interpretará como un error. Si se ha indicado la directiva User =, se puede escribir "~" como valor de esta directiva, equivalente así a la ruta de la carpeta personal del usuario indicado en User =.

- **StandardOutput** = {null | tty | journal | socket}
    Indica donde se imprimirá la salida estándar de los programas indicados en las directivas ExecStart =, y ExecStop =. El valor "null" representa el destino / dev / null. El valor "tty" representa un terminal (ya sea de tipo virtual - / dev / ttyX- o pseudo - / dev / pts / X-), el cual deberá ser especificado mediante la directiva TTYPath = . El valor "journal" es el valor por defecto (es decir, que si el programa en cuestión imprimiera algo en la pantalla del terminal al ejecutarse en primer plano, esta salida se redireccionará el Journal en ejecutarse vía un archivo .service). El valor "socket" sirve para indicar que la salida debe enviarse al socket asociado al servidor con el fin de viajar al otro extremo de la comunicación (ver más adelante).

    !!!NOTE "NOTA"
        NOTA: El hecho de que por defecto la salida estándar vaya a parar en el Journal se puede cambiar de forma general para todas las Units en la directiva DefaultStandardOutput del archivo `/etc/systemd/system.conf`

    !!!NOTE "NOTA"
        También existe la directiva StandardError = {null | tty | journal | socket} , similar a StandardOutput = pero para la salida de error

##EJERCICIOS
Todos los ejercicios se harán en una máquina virtual donde el usuario pueda tener permisos de administrador:

1. A) Ejecutar `systemctl list-Units -t service | grep ufw` (si estás en Ubuntu) o `systemctl list-Units -t service | grep firewalld` (si está en Fedora). ¿Qué significa la palabra "loaded"? Y "active"? Confirma esto ejecutando `systemctl status ufw / systemctl status firewalld`

    B) Ahora enmascara la Unit ufw / firewalld. ¿Qué pasa realmente cuando s'enmascara una Unit? Pista: consulte donde apunta el recién creado archivo `/etc/systemd/system/ufw.service` (o `/etc/systemd/system/firewalld.service`)

    C) Ejecutar systemctl list-Units -t service | grep ufw (o systemctl list-Units -t service | grep firewalld ) de nuevo.
    ¿Por qué todavía aparece la palabra "active"? Confirma esto ejecutando `systemctl status ufw` / `systemctl status firewalld`

    D) Si ahora ejecutas `systemctl stop ufw` (o `systemctl stop firewalld` ) , ¿qué muestra `systemctl list-Units -t service | grep ufw (o systemctl list-Units -t service | grep firewalld` )? ¿Por qué? ¿Qué deberías hacer para que vieras algo? Pista: usa el parámetro --all

    E) Ejecutar el comando systemd-delta . ¿Qué significa la relación indicada entre los dos archivos que aparecen en la línea [Masked]? ¿Y entre los dos archivos que aparecen en las líneas [EXTENDED]?
    
    !!!NOTE "NOTA"
        También podría haber alguna pareja de archivo en líneas [overrides] o incluso [EQUIVALENTE]

    F) Intenta iniciar el Unit ufw (o firewalld) todavía Enmascarado. Puedes? Desenmascara y vuelve a intentarlo. puedes ahora?

    G) Ejecutar el comando `systemctl edit ufw` (o `systemctl edit firewalld` ) y, en el editor de texto que aparece, escribe la línea Description = Hola amigo y guarda. A continuación, ejecuta systemctl cat ufw (o systemctl cat firewalld ) . ¿Qué ves? Y si vuelves a ejecutar systemd-delta ?

2. A) Crear un archivo llamado `/etc/systemd/system/pepe.service` con el siguiente contenido ...:
``` BASH
[Unit]
Description = Pepe se colega
[Service]
Type = oneshot
ExecStart = / bin / ls -l
ExecStop = / bin / df -h
[Install]
WantedBy = multi-user.target
```
... y a continuación (después de `systemctl daemon-reload`) ejecuta `systemctl start pepe` Qué ves? Y si haces `journalctl -e`, ¿qué ves? ¿Por qué?

B)  ¿Qué deberías modificar del archivo anterior para que el comando `/bin/df -h` no se ejecutara justo después de `/bin/ls -l` sino sólo cuando se escriba `systemctl stop pepe` ? Pista: consulta la explicación del tipo "oneshot" en la teoría. Pruébalo utilizando los comandos `systemctl -full edit pepe`, `systemctl daemon-reload` y, de nuevo, `journalctl -e`

C) Para qué sirve la línea `WantedBy = ...` ? O dicho de otro modo: ¿qué relación tiene esta línea con el comando `systemctl enable` ? Pista: observa el contenido de la carpeta `/etc/systemd/system/multi-user.target.wants`

D) ¿Qué deberías modificar del archivo anterior para que la salida de los comandos ejecutadas por la Unit (ya sea ​​a ExectStart = o a ExecStop =) no vaya a parar al Journal sino que se visualice el terminal / dev / tty4? Pruébalo.

3.-a) Crear un script llamado `/opt/yeah` con el siguiente contenido (y dale permisos de ejecución):

```BASH
#!/bin/bash
while [[true]]
do
curl -s ipinfo.io/ip
/ Bin / sleep 3```
dé
```

b) Crear un archivo llamado "/etc/systemd/system/pepa.service" con el siguiente contenido ...:
```
[Unit]
Description = Pepa se colega
[Service]
Type = simple
ExecStartPre = / usr / bin / systemd-cat -t PEPA -p grito echo "Empieza"
ExecStart = / opt / yeah
ExecStop = / usr / bin / systemd-cat -t PEPA -p grito echo "Termino"
# StandardOutput = null
[Install]
WantedBy = multi-user.target
```
... y a continuación (después de `systemctl daemon-reload`) ejecuta `systemctl start pepa`. Si haces `journalctl -f`, que ves? ¿Por qué? Y si ejecutas `systemctl stop pepa` , que ves entonces en el Journal? ¿Por qué? Y si Descomentas la línea que aparece comentada y vuelves a probar?

4.-a) Crear un archivo llamado "fiufiu.service" dentro de "/ etc/systemd / system" con el siguiente contenido ...:
```
[Unido]
Description = All we are saying is give peace a chance
[Service]
Type = simple
ExecStart = /usr/bin/nc -l -p 5555
Restart = on-success
```

... y seguidamente ponerlo en marcha con el comando `sudo systemctl start fiufiu` . Comprueba con `systemctl status fiufiu` (o también con `ss -tnl` ) que se haya iniciado correctamente

b) Ejecutar el comando `journalctl -ef` y seguidamente, abre otro terminal para ejecutar en ellos el comando `nc 127.0.0.1 5555` . Escribe algo la conexión abierta para este cliente Netcat y observa a la vez lo que aparece en tiempo real en el Journal. ¿Qué pasa? ¿Por qué?

c) Cerrar el cliente y vuelve a ejecutar. ¿El servicio sigue funcionando? Ahora comenta la línea Restart = ... que aparece en el archivo fiufiu.service, reinicia el servicio y vuelve a ejecutar el cliente un par de veces. la primera
vez deberá conectarse sin problemas como siempre pero la segunda ya no. ¿Por qué?

5.-a) Instal.la el paquete "apache2" y observa, ejecutando el comando `systemctl cat apache2` , el valor que tiene la directiva Restart =. Ejecuta entonces `systemctl --signal = 9 kill apache2` y comprueba con systemctl status
apache2 si el servicio reinicia solo o no. ¿Por qué pasa lo que pasa?

b) Cambiar ahora el valor de la directiva Restart = del Unit del Apache2 mediante `systemctl edit --full apache2` para que valga "no" (recuerda que escribir como primera línea el título de la sección a la que pertenece la directiva que quieres sobreescribir -es decir, [Service] -). Después de hacer `systemctl daemon-reload` (y de comprobar que la modificación es efectiva con `systemd-delta` o también `systemctl cat apache2`) , inicia el servicio de nuevo y comprueba que efectivamente esté iniciado. Vuelve a matar de nuevo con `systemctl -signal = 9 kill apache2` y vuelve a comprobar de nuevo si el servicio ha reiniciado automáticamente o no. ¿Qué pasa ahora?

c) Agregar mediante `systemctl edit apache2` la línea necesaria para llamar a una Unit que se encargue ejecutarse en el modo "oneshot" el comando `play /ruta/un/fitxer.mp3` cada vez que el Apache finalice debido a alguna situación inesperada (como por ejemplo sería una señal kill 9)
    
!!!NOTE "NOTA"
    El comando play encarga de reproducir el archivo de sonido indicado y admite muchos formatos posibles, no sólo mp3. Forma parte del paquete "sox"

6.a) Ejecuta `systemctl disable ufw` (o `systemctl disable firewalld` ) y seguidamente `systemctl show --property "Wants" multi-user.target | grep -E "(ufw | firewalld)`" ¿Qué ves? ¿Por qué? Pista: observa el mensaje que
aparece en pantalla al deshabilitar el servicio ufw

b) Y si ahora ejecutas `systemctl enable ufw` (o `systemctl enable firewalld` ) y vuelves a ejecutar el mismo comando? ¿Qué ves ahora? ¿Por qué? Pista: observa el contenido de la carpeta /etc/systemd/system/multi-user.target.wants

c) Deduce y di por qué la línea After = de la Unit ufw.service (o firewalld.service) tiene el valor que tiene.

d) systemd puede no ser el proceso INIT de nuestro sistema Linux: aunque sea el más extendido con diferencia, te puedes encontrar distribuciones que utilicen sistemas INIT alternativos. Dime, de los siguientes comandos,
cuáles sirven para comprobar si el proceso INIT de tu sistema es systemd (o no):

- file /sbin/init
- man init
- pgrep ^systemd $

#Systemd (II)
##targets
Podemos definir un "target" como un "estado" del sistema definido por un determinado conjunto de servicios puestos en marcha (y otros que no). La idea es que, al arrancar el sistema, se llegue a un determinado "target" (Y, opcionalmente, a partir de allí, poder pasar a otro si fuera necesario). A continuación se listan los "targets" más importantes (todos ellos ubicados dentro de `/usr/lib/systemd/system`):

- **poweroff.target** (o "runlevel0.target") Si se llega a este "target", se apaga el sistema
- **reboot.target** (o "runlevel6.target"): Si se llega a este "target", se reinicia el sistema
- **rescue.target** (o "runlevel1.target"): Si se llega a este "target", se inicia el sistema en modo texto,sin red y sólo por el usuario root. Sería similar a otro target llamado " emergency.target ", pero el "emergency" es más "radical" que el "rescate" porque gracias a montar la partición raíz en modo sólo lectura permite arrancar sistemas que el "rescate" quizás no puede.
- **multi-user.target** (o "runlevel3.target"): En este caso se inicia el sistema en modo texto pero con red y multiusuario (el target predeterminado en servidores)
- **graphical.target** (o "runlevel5.target"): En este caso, se inicia el sistema en modo gráfico con red y multiusuario (el target por defecto en sistemas de escritorio) Implica haber pasado por el target "multi-user" previamente.

Otros targets predefinidos que se instalan con systemd y que hay que conocer son:

- **ctrl-alt-del.target** Target activado cuando es pulsado CTRL + ALT + SUPR. Por defecto es un enlace a "reboot.target"

- **sysinit.target** Target que ejecuta los primeros scripts de arranque

- **sockets.target** Target que activa, al arrancar, todas las Units de tipo "socket". Se recomienda, por tanto, que todos los archivos de configuración de una Unit "socket" tengan a su línea Wants = este target indicado (o bien WantedBy =)

- **timers.target** Target que activa, al arrancar, todas las Units de tipo "timer". Se recomienda, por tanto, que todos los archivos de configuración de una Unit "timer" tengan a su línea Wants = este target indicado (o bien WantedBy =)

- **paths.target** Target que activa, al arrancar, todas las Units de tipo "path". Se recomienda, por tanto, que todos los archivos de configuración de una Unit "path" tengan a su línea Wants = este target indicado (o bien WantedBy =)

- **swap.target** Target que habilita la memoria swap

- **basic.target** Target que pone en marcha todos los target relacionados con puntos de montaje, memorias swaps,paths, timers, sockets y otras unidades básicas necesarias para el funcionamiento del sistema.

- **initrd-fs.target** El generador systemd-fstab-generator añade automáticamente las Units indicadas en la directiva Before = de esta Unit a la Unit especial "sysroot-usr.mount" (además de todos los puntos de montaje existentes en `/etc/fstab` que tengan establecidas las opciones "auto" y "X-initrd.mount"). Ver más adelante una explicación de las Units de tipo mount.

- **initrd-root-fs.target** El generador systemd-fstab-generator añade automáticamente las Units indicadas en la directiva Before = de esta Unit a la Unit especial "sysroot-usr.mount", la cual es generada a partir de los parámetros del kernel. Lo estudiaremos más adelante

- **local-fs.target** El generador systemd-fstab-generator añade automáticamente las Units indicadas en la directiva Before = de esta Unit a todas las Units de tipo "mount" que se refieren a puntos de montaje locales. También añade a este target las dependencias de tipo Wants = correspondientes a los puntos de montaje existentes en /etc/fstab que tienen la opción "auto" establecida. Ver más adelante una explicación de las Units de tipo mount.

- **network-online.target** Target que se activa automáticamente en cuanto el subsistema de red es funcional.Cualquier servicio que tenga que trabajar en red se deberá iniciar al menos en este target

    !!!NOTE "NOTA"
        Existe otro tarjet relacionado con la red llamado "pre-network.target" que está pensado para iniciar servicios antes de que cualquier tarjeta de red se configure. Su propósito principal es hacerlo servir con servicios de tipo cortafuegos, para establecer las reglas antes de que la configuración de red funcione. Estos servicios deberán tener una línea Before = network-pre.target y también una línea Wants = network-pre.target en su archivo de configuración 

    !!!NOTE "NOTA"
        Existe otro tarjet relacionado con la red llamado simplemente "network.target" que sólo indica que el stack software de red ya se ha cargado en memoria pero esto no implica que las interfaces se hayan configurado todavía. este target está más pensado para el proceso de apagado de la máquina para realizar este proceso de forma ordenada: pues la orden de apagado es al revés que el de arranque, cualquier Unit que tenga una línea After = network.target apagará antes que la red se descargue y esto hará que esta Unit apague sin interrumpir ninguna conexión que esté pendiente

- **printer.target** Target que se activa automáticamente tan pronto como una impresora es enchufada o aparece disponible durante el arranque. Aquí donde se suele iniciar, por ejemplo, el servicio Cups.

- **sound.target** Target que se activa automáticamente tan pronto como una tarjeta de audio es enchufada o aparece disponible durante el arranque.

- **bluetooth.target** Target que se activa automáticamente tan pronto como un controlador Bluetooth es enchufado o aparece disponible durante el arranque.

- **smartcard.target** Target que se activa automáticamente tan pronto como un controlador Smartcard es enchufado o aparece disponible durante el arranque.

- **system-update.target** Target especial utilizada para actualizaciones del sistema. El generador systemd-System- update-generator redireccionará el proceso de arranque automáticamente a este target si la carpeta /system-update existe

- **umount.target** Target que desmonta todos los puntos "mount" y "automount" durante el apagado del sistema 
 
- **final.target** Target utilizado durante el apagado del sistema que puede utilizarse para apagar los últimos servicios después de que los servicios "normales" ya se han detenido y los puntos de montaje se han desmontado.

Para saber el target donde nos encontramos en este momento podemos hacer: `systemctl get-default`

Hay que tener en cuenta que múltiples targets pueden estar activados a la vez. Un target activado indica que systemd ha intentado iniciar todas las Units asociadas a este target. Esto significa que el comando anterior sólo nos dice cuál es el target "final" donde hemos llegado, pero a lo largo del camino desde el arranque de la máquina hasta llegar a este target "final" se han ido activando diferentes targets a modo de "escalones" intermedios. para
ver todos los targets activados, hay que hacer `systemctl list-Units -type = target`

Se puede cambiar el target actual a otro simplemente ejecutando: `systemctl Isolate nomTargetDesti.target` 

Para cambiar el target por defecto donde irá a parar automáticamente a cada arranque del sistema se puede hacer: `systemctl set-default nomTargetDefecte.target`

!!!NOTE "Nota"
    El comando anterior, en realidad lo único que hace es revincular el link "/etc/systemd/system/default.target" en el archivo * .Target adecuado.

!!!NOTE "Nota"
    Otra manera de entrar al final del arranque del sistema en un determinado target predeterminado es añadir la línea systemd.unit = nomTargetDestino.target a la lista de parámetros del kernel indicada en la configuración del gestor de arranque. Hay una serie de comandos específicos para pasar a determinados estados (poweroff, reboot, etc) que se pueden usar en vez del comando systemctl Isolate genérica. Por ejemplo:
        `sudo systemctl rescue` : Similar a `systemctl Isolate rescue.target`
        `sudo systemctl poweroff` (o `sudo poweroff` a secas): Similar a -  `systemctl Isolate poweroff.target`
        sudo systemctl reboot (o sudo reboot a secas): Similar a systemctl Isolate reboot.target

Si se quiere detener (-P) o reiniciar (-r) la máquina en un momento futuro determinado (hh: mm), entonces habrá que ejecutar el comando: `sudo shutdown {-P | -r} hh: mm`

Si se quiere detener (-P) o reiniciar (-r) la máquina dentro de una cierta cantidad de minutos, entonces habrá que ejecutar el comando: `sudo shutdown {-P | -r} + m`

!!!NOTE "Nota"
    Dentro de la carpeta `/usr/lib/systemd/system-shutdown` pueden haber archivos * .shutdown, que son scripts ejecutables que se ejecutarán justo antes del apagado / reinicio del sistema (es decir, justo al poner en marcha los servicios "poweroff.service" o "Reboot.service"). Quien ejecutará estos scripts es el binario /usr/lib/systemd/systemd-shutdown, el cual es invocado siempre por estos servicios, que lo colocan como PID 1 y es el responsable de desmontar los sistemas de ficheros, deshabilitar la swap, matar los procesos que queden pendientes, etc. En los scripts ejecutados por /usr/lib/systemd/systemd-shutdown podemos utilizar un parámetro ($1) que puede valer "poweroff" o "reboot" dependiendo de la acción que realizará y que nos podría servir para distinguir qué queremos que haga este script según la acción indicada. Todos los scripts se ejecutan en paralelo. Hay que tener en cuenta, finalmente, que el sistema de ficheros en ese momento permanece montado pero en modo sólo lectura.

!!!NOTE "Nota"
    En el comando systemctl reboot le podemos añadir varios parámetros interesantes, los cuales sólo funcionan, sin embargo, en sistemas UEFI que han arrancado mediante el gestor de arranque systemd-boot:

    -  --firmware-setup : INDICATE to the system s firmware to reboot into the firmware setup interface (aka the "UEFI control panel")
    -  --boot-loader-menu = nºsegons : INDICATE to the system s boot loader to show the boot loader menu on the following boot the number of seconds specified as value. Pass 0 value in order to disable the menu timeout.
    - -boot-loader-entry = entryID : INDICATE to the system s boot loader to boot into a specific boot loader entry on the following boot.

Lo que hacen los parámetros anteriores es modificar determinados valores de variables EFI concretas (tal como se podría haber hecho también con el comando efibootmgr ) para así modificar el comportamiento de la UEFI el próximo arranque

Por otra parte, con el comando sudo systemctl suspend podemos suspender el sistema (o dicho de otro manera, nos permiten llegar al target suspend.target") y con el comando sudo systemctl hibernate la
podemos poner a hibernar (o dicho de otro modo, permiten llegar al target "hibernate.target").

"Suspender" significa que se guarda todo el estado del sistema en la RAM y se apaga la mayoría de dispositivos de la máquina; cuando se pone en marcha de nuevo, el sistema restaura su estado previo de la RAM sin tener que reiniciarse
de nuevo: este proceso es muy rápido pero tiene el inconveniente de que obliga a mantener con alimentación eléctrica la máquina todo el tiempo. 

"Hibernar" significa que se guarda todo el estado del sistema en el disco duro (si tiene espacio libre) y se apaga por completo la máquina: cuando se pone en marcha de nuevo, el sistema restaura su estado previo desde el disco duro sin tener que reiniciar de nuevo: este proceso es bastante lento pero tiene la ventaja de no tener que mantener con alimentación eléctrica la máquina.

!!!NOTE "Nota"
    Dentro de la carpeta "/ usr / lib / systemd / system-sleep" pueden haber archivos * .sleep, que son scripts ejecutables que se ejecutarán justo antes de la hibernación o suspensión del sistema (es decir, justo en poner en marcha internamente los servicios "systemd-hibernate.service "o" systemd-suspend.service ", los cuales, por cierto, nunca deben ser invocados directamente con systemctl start ... sino utilizando los comandos explicadas en el párrafo anterior: systemctl hibernate o systemctl suspend ). Quien ejecutará estos scripts es el binario / usr / lib / systemd / systemd-sleep, el cual es invocado siempre por estos servicios y admite dos parámetros que podemos utilizar en estos scripts como $ 1 y $ 2 respectivamente. El primer parámetro puede valer "pre" o "post" dependiendo de si la máquina está yendo a la suspensión / hibernación o está volviendo, respectivamente. El segundo parámetro puede valer "suspend" o "hibernate" dependiendo de la acción que realizará y que nos podría server para distinguir qué queremos que haga este script según la acción indicada. Todos los scripts ejecutan en paralelo.

Si se quiere realizar una tarea larga y asegurarse de que la máquina no se suspenderá o apagará mientras tanto,
se puede invocar el comando correspondiente a esta tarea así: systemd-inhibido comanda_llarga El comando
systemd-inhibido --list muestra las tareas que tienen este truco en marcha. Si se quiere especificar una acción
concreta a inhibir se puede indicar con el parámetro - what = acción , donde "acción" puede ser por ejemplo la palabra
"Shutdown" o "sleep" (equivalente a hibernación o suspensión), entre otros. Encontrará más información en los
primeros párrafos de https://www.freedesktop.org/wiki/Software/systemd/inhibit/
Para que el inicio con systemctl start de un determinado servicio (o target) se produzca dentro de un target
determinado -llamado-el "a.target" - desde el propio archivo de configuración del servicio en cuestión hay que escribir
las directivas Wants = a.target, Requires = a.target y / o After = a.target (estas directivas se aseguran de llegar
primero al target "a.target" para iniciar entonces el servicio en cuestión). Por otra parte, también existe la directiva
Conflicts = a.target , la que se asegura de no estar en el target "a.target" para poder iniciar el servicio en cuestión.
En el caso de querer iniciar siempre un servicio determinado automáticamente en el target "a.target", entonces
habrá que escribir además las directivas WantedBy = a.target o RequiredBy = a.target del archivo de configuración del
servicio (en este último caso, al hacer systemctl enable nomServei se crea un enlace a su archivo de configuración
dentro de "/lib/systemd/system/a.target.wants").
Los archivos de configuración de los targets sólo tienen secciones [Unido] (y muy pocas la sección
[Install]). En este sentido, es interesante consultar los archivos correspondientes, por ejemplo, a multi-user.target
o graphical.target: sólo encontramos las directivas Description, Documentation, Wants, Requires, After,
Conflicts y AllowIsolate (ya partir de ellas podemos deducir las dependencias que hay entre targets ... aunque
por eso hay comandos específicos que enseguida veremos).


#EJERCICIOS:

1. Crear un target nuevo llamado "manolo.target" donde el sistema deberá entrar justo después de activar graphical.target (es decir, debe ser el último target al activarse). La idea será asegurarte de que entras en este target para ejecutar un determinado servicio (lo llamaremos "manolo.service") el último de todos. para hacer esto, tienes que hacer lo siguiente:
     
     A) Crear un nuevo fichero llamado "/etc/systemd/system/manolo.target" con el siguiente contenido:
       
        [Unit]
        Description = Manolo is kind
        Documentation = http: //www.lecturas.com
        Requires = graphical.target
        After = graphical.target
        Conflicts = rescue.service rescue.target
        AllowIsolate = yes
        
            
    B) Crear un nuevo fichero llamado "/etc/systemd/system/manolo.service" con el siguiente contenido:

        [Unit]
        Description = Manolo is soberbio
        Documentation = http: //www.hola.com
        Requires = manolo.target
        After = manolo.target
        [Service]
        ExecStart = / usr / bin / printf "MANOLO \ n"
        RemainAfterExit = yes
        [Install]
        WantedBy = manolo.target

    C) Ejecutar systemctl enable manolo.service y reinicia la máquina. ¿Crees que el servicio "manolo" estará funcionando automáticamente o no? ¿Por qué lo crees? Compruébalo ejecutando el comando `systemctl status manolo.service` (o también observando si aparece la palabra "MANOLO" en el Journal). PISTA: La respuesta de porque el servicio "manolo" estará funcionando (o no) se encuentra en lo que muestra el comando `systemctl list-Units -t target | grep "manolo"` y en entender el significado de la línea WantedBy =

    D) A continuación ejecuta systemctl start manolo.service . Después de observar que el servicio se haya puesto en marcha
    correctamente (en la salida del comando systemctl status manolo.service o también observando si aparece la
    palabra "MANOLO" en el Journal), ¿crees que el comando systemctl list-Units -t target | grep "manolo"
    mostrará algo diferente respecto del apartado anterior? ¿Por qué lo crees? PISTA: La respuesta se encuentra en
    entender el significado de las líneas Requires = y After = del archivo "manolo.service"

    e) Ejecutar systemctl set-default manolo.target y vuelve a reiniciar la máquina. ¿Crees que el servicio "manolo" ahora estará funcionando automáticamente o no? ¿Por qué lo crees? Compruébalo ejecutando el comando systemctl status manolo.service (o también observando si aparece la palabra "MANOLO" en el Journal). PISTA: La respuesta se encuentra en entender el significado de las líneas Requires = y After = del archivo "manolo.target"

2. A) Entra en el target de rescate. ¿Qué pasa?

    B) Entra en el target de suspensión. ¿Qué pasa?

    C) Entra en el target multi-user. ¿Qué pasa?

    D) Crear un script ejecutable dentro de la carpeta "/usr/lib/systemd/system-sleep" con el siguiente contenido ...:

        #! / Bin / bash
        if [[ "$ 1" == "pre"]]
        then
        echo "we are suspending oro hibernating at $ (date) ..."> / tmp / systemd_suspend_test
        Elif [[ "$ 1" == "post"]]
        then
        echo "... and we are back from $ (date)" >> / tmp / systemd_suspend_test
        fin

    ... y prueba a suspender el sistema y volver a "despertar". ¿Qué pasará?

e) ¿Para qué sirve este programa: https://github.com/ryran/reboot-guard ?

###boot chain
Para saber la jerarquía de dependencias de targets para llegar a iniciar un target (o service!) Determinado se puede utilizar el comando: `systemctl list-dependencies nomTarget.target` (o nomUnit.service )

!!!NOTE "Nota"
    Una forma alternativa de obtener una información similar sería ejecutando `systemctl show -p "Wants" nomTarget.target && systemctl show -p "Requires" nomTarget.target` . También se puede ejecutar `systemctl status` Las dependencias mostradas se corresponden a Units que han sido "required" o "wanted" por las Units superiores. Las dependencias recursivas sólo se muestran los targets intermedios; si se quieren ver también por los service, mounts paths, socket, etc intermedios hay que incluir el parámetro --all al comando anterior.

También se pueden mostrar cuáles Units dependen para funcionar del correcto inicio de un target (o service!) determinado con el comando: `systemctl list-dependencias --reverse nomTarget.target` (o nomUnit.service )

!!!NOTE "Nota"
    Una forma alternativa de obtener una información similar sería ejecutando `systemctl show -p "WantedBy" nomTarget.target && systemctl show -p "RequiredBy" nomTarget.target`

Otros parámetros interesantes de este comando son --before y - after , los cuales sirven para mostrar Units que dependen para funcionar del correcto inicio anterior o posterior de un target, respectivamente.

Por otra parte, respecto al arranque del sistema podemos obtener una información más detallada sobre los tiempos que tarda cada Unit en cargarse y el orden en que lo hace gracias al comando systemd-analyze, tiene varias posibilidades

- **systemd-analyze** : Muestra el tiempo total empleado en el arranque del sistema y qué parte de este tiempo ha sido
empleado en tareas del kernel, qué parte en uso de initrd y qué parte en tareas de usuario

- **systemd-analyze blame** : Muestra los tiempos disgregados por servicio. Hay que indicar que estos tiempos son "en paralelo ", así que la suma total que sale será siempre muy superior al tiempo real empleado en el arranque.

- **systemd-analyze dot [nomTarget.target] | dot -T {png | svg} -o foto. {png | svg}** : Genera una salida que si se pasa a la aplicación "dot" (perteneciente al paquete "GraphViz") generará finalmente un gráfico (En formato png o svg) donde se pueden visualizar todas las dependencias del target (o servicio!) indicado (o, si no se indica, del "default.target"; también se pueden indicar comodines en el nombre del target / servicio).

- **systemd-analyze plot [nomTarget.target]> something.svg** : Genera un gráfico donde se muestra los tiempos de ejecución y de bloqueo de cada Unit durante el arranque hasta llegar al target (o servicio!) indicado (o, si no se indica, del "default.target")

- **systemd-analyze critical-chain [nomTarget.target]** : Muestra el árbol de dependencias bloqueantes por target (o servicio!) indicado. El tiempo mostrado después de "@" indica el tiempo que hace que la Unit está activa; el tiempo
mostrado después de "+" indica el tiempo que la Unit ha tardado en activarse.
Otras opciones del comando `systemd-analyze` son syscall-filter, verify, dump, log-level, security, time ...Se puede ver si, una vez iniciado el sistema, aún quedan tareas pertenecientes al arranque para completar ejecutando el comando `systemctl list-jobs`


###EJERCICIOS:
1.- a) ¿Qué targets deben haberse iniciado para que el servicio gdm se pueda poner en marcha? (esto lo puedes saber con el comando systemctl list-dependencies ... )

b) Ejecutar el comando systemctl `list-dependencies --reverse gdm.service` Qué ves?

c) ¿Qué hace el comando tree / etc / systemd / system y para qué podría servirte?

2.-a) Ejecutar systemd-analyze plot ... y observa qué Unit bloquea más tiempo el arranque de tu sistema. prueba de desactivarla (esperemos no romper nada!) y reinicia. Ejecuta ahora systemd-analyze blame para comprobar si el
tiempo total de arranque ha disminuido efectivamente.

b) Instal.la el paquete "GraphViz" y genera un gráfico Png con las dependencias del target multi-user. Haz una lista de las dependencias allí mostradas y adjunta la captura del gráfico plantillas Una plantilla es un archivo de configuración de tipo "service" que tiene la particularidad de permitir poner en marcha variantes de un mismo servicio sin tener que escribir un archivo "service" diferente para cada variante.
Básicamente, para utilizar una plantilla hay que hacer los siguientes pasos:
1.- El archivo "service" que hará de plantilla debe llamarse "nomServei @ .service". Es decir, hay que indicar
el símbolo arroba antes del punto
2.- El contenido de este archivo plantilla puede ser exactamente igual que el de un archivo "service" estándar
3.- A la hora de iniciar, parar, activar, desactivar, ver el estado, etc de una plantilla, se deberá indicar
el identificador concreto de la variante con la que queremos trabajar. Este identificador se establece la
primera vez que arranca la variante y simplemente consiste en una cadena entre la arroba y el punto,
así: systemctl start nomServei @ identificador. service A partir de aquí, este identificador se hará
servir de la misma manera por el resto de tareas relacionadas con la gestión de esta variante
NOTA: An instance file is usually created as a symbolic link to the template file, with the link name including the instance
identifier. In this way, multiple links with unique Identifiers can point back to a single template file. When managing año
instance Unit, systemd will look for a file with the exact instance name you Specify on the command line to use but if it
can not find one, it will look for an associated template file.
4.- La gracia de las plantillas es que el valor del identificador indicado en el punto anterior se puede utilizar
dinámicamente dentro del contenido del archivo plantilla (concretamente mediante el símbolo " % y "), de
lo que según el valor que haya adquirido% y por esa variante se podría poner en marcha el
servicio escuchando en un puerto diferente (si% y representa un número de puerto), o bien utilizando un archivo de
configuración diferente (si% y representa un nombre de archivo), o lo que nos convenga.
NOTA: Otros símbolos especiales que se pueden indicar en un archivo de configuración de una plantilla pueden ser
% p : representa the Unit name prefijo (this is the Portion of the Unit name that comes before the @ symbol)
% n : representa the full resulting Unit name (% p plus% e)
% u : The name of the user configured to run the Unit.
% U : The same as above, but as a numeric UID instead of name.
% H : The host name of the system that is running the Unit.
%% : This is used to insert a literal percentage sign.
Page 20
Pongamos un ejemplo. Imaginemos que tenemos un determinado servidor web que queremos ejecutar con dos
configuraciones diferentes a la vez. La solución sería crear un archivo plantilla llamado por ejemplo
"Servidorweb @ .service" con un contenido similar al siguiente:
[Unido]
Description = My HTTP server
[Service]
Type = simple
ExecStart = / usr / sbin / WebServer --config-file /etc/%i.conf
[Install]
WantedBy = multi-user.target
Con este archivo, se podría iniciar entonces el servidor dos veces, cada una indicando el nombre del archivo de
configuración deseado, así:
sudo systemctl start servidorweb@config1.service
sudo systemctl start servidorweb@config2.service
Los comandos anteriores lo que harán será ejecutar, respectivamente, los comandos: / usr / sbin / WebServer -
config-file /etc/config1.conf y / usr / sbin / WebServer -config-file /etc/config2.conf
EJERCICIOS:
1.-a) Crear un archivo plantilla que permita poner en marcha diferentes servidores Ncat de forma permanente
(Recuerda el parámetro -k) escuchando cada uno de ellos en un puerto diferente.
NOTA: Deberás instalar el paquete "nmap" para disponer del comando ncat
b) Iniciar un servidor Ncat a partir de la plantilla anterior escuchando en el puerto 2.222 y otro escuchando en el puerto
3333. Comprueba que, efectivamente, estos dos puertos estén abiertos observando la salida del comando ss
-tnl
c) Conecta con el cliente Ncat a uno de los servidores anteriores y envíale algún mensaje. Cerrar el cliente (con
CTRL + C) y ahora vuelve a ejecutarlo para conectar al otro servidor; vuelve a enviarle algún otro mensaje y
ciérralo de nuevo. Observa las últimas líneas del Journal: ¿qué ves?
2.- Lee el siguiente párrafo y seguidamente contesta:
When the user switches consolas using Ctrl + Alt + F2, Ctrl + Alt + F3, and so on, a new terminal then is spawned. in this
case systemd callos a service named getty @ .service providing the appropriate argumento such as tty2 oro tty3 to the Unit
file. The% y identifier provides this argumento value to the agetty binary sonido the terminal starts on that new console (as it
can seen in ExecStart = line from template file).
a) Para qué sirve el comando agetty? Busca en su página del manual que hace su parámetro -ay
añádelo a la invocación del comando escrita a la línea ExecStart de dentro del archivo getty @ .service (recuerda
de ejecutar sudo systemctl daemon-reload justo después). ¿Qué pasa ahora cuando pulses Ctrl + Alt + F2, etc?
b) enmascarado la instancia tty5 de la plantilla getty @ .service. ¿Qué pasa ahora si haces Ctrl + Alt + F5?
NOTA: Es posible que también hayas de enmascarar la plantilla autovt @ .service para que funcione el ejercicio
NOTA: Hay otras maneras más sofisticadas de desactivar terminales virtuales pero las veremos más adelante
c) ¿Qué te muestra el comando systemctl status getty @ * ?
Page 21
3.- Supone que tienes un archivo llamado "/etc/systemd/system/pepe@.service" con el siguiente contenido:
[Unido]
Description = lerele
[Service]
Type = oneshot
ExecStart = / usr / local / bin / systemd-email% y admin@elpuig.xeill.net
User = nobody
Group = systemd-journal
donde "systemd-email" es un bash shell script escrito por nosotros diseñado para enviar correos (suponiendo que
tenemos un servidor Postfix o similar configurado en la máquina) que tiene el siguiente código:
#! / Bin / bash
systemctl status -full "$ 1" | mail -s "$ 1" $ 2
y supone que has añadido la línea OnFailure=pepe@%i.service en la sección [Unido] del archivo ".service"
correspondiente al / los servicio / s que quiere monitorear.
a) ¿Cuál comando deberías ejecutar para poner en marcha una instancia del servicio-plantilla pepe @ que
se encargan de enviar mails en el momento que el servicio Cups falle?
sockets
Un aspecto muy interesante de systemd es que permite que un servidor no esté permanentemente
encendido sino que sólo arranque "bajo demanda" (es decir, cuando detecte una conexión, normalmente externa).
De este modo, este servidor no consume más recursos que los mínimos imprescindibles, en el momento
justo. Para lograr esto, lo que pasa es que sí hay un componente "escuchando" todo el rato posibles
intentos de conexiones, pero este componente no es la Unit "service" en sí sino un "perro guardián" que
sólo despertará Unit "service" cuando sea necesario. Este "perro guardián" es la Unit de tipo "socket".
Cada archivo de configuración de una Unit "socket" debe tener exactamente el mismo nombre que el archivo de
configuración de la Unit "service" que quiere despertar (es decir, si tenemos el servicio "a.service", el socket
correspondiente deberá llamarse "a.socket"). La idea es tener la Unit "socket" siempre encendido ( systemctl
enable a.socket ) pero la Unit "service" no ( systemctl disable a.service ); cuando se detecte una conexión, el
"socket" automáticamente encenderá la Unit "service" (esto se puede ver haciendo systemctl status a.service mientras
existe la conexión) y la apagará de nuevo pasado un determinado tiempo sin actividad (por defecto 5 minutos).
Obviamente, si paráramos el "socket" ( systemctl stop a.socket ) o el deshabilitéssim el próximo reinicio ( systemctl
disable a.socket ) ya no habría "perro guardián" atento y, por tanto, el servicio ya no se pondría en marcha
automáticamente.
Para cambiar el puerto donde escucha un "socket" (entre otras cosas) hay que modificar la configuración del
"Socket" propiamente dicho y eso no depende de la configuración del servidor en cuestión. Los archivos de configuración
de cada "socket" se pueden encontrar, como cualquier otra Unit, o bien dentro de la carpeta "/ usr / lib / systemd / system"
o bien dentro de "/ etc / systemd / system" y se puede utilizar igualmente el comando systemctl edit a.socket para
generar archivos "override". La sección que nos interesa en estos tipos de ficheros es la sección [Socket] , lo
puede contener alguna de las siguientes directivas más importantes:
ListenStream = [IP:] nºport
Indica el número de puerto TCP por donde escuchará el socket. Opcionalmente, se puede indicar una IP
concreta para especificar que sólo escuchará en el puerto ofrecido por aquella IP y ninguna más.
NOTA: Se pueden indicar varias líneas ListemStream para hacer que el socket escuche en varios puertos a la vez. Por otra parte,
como que esta línea puede estar escrita en diferentes archivos, si se quiere asegurar que sólo se escuche en un puerto concreto sin
tener en cuenta otras líneas que pueda haber leído systemd previamente, se puede añadir primero una línea ListemStream vacía
(así: ListemStream = ) y luego la línea ListenStream asociada al puerto deseado; lo que hace la línea ListemStream vacía es
"resetear" todas las líneas ListemStream anteriores
Page 22
ListenDatagram = [IP:] nºport
Indica el número de puerto UDP por donde escuchará el socket. Opcionalmente, se puede indicar una IP
concreta para especificar que sólo escuchará en el puerto ofrecido por aquella IP y ninguna más.
ListenSequentialPacket = / ruta / arxiu.socket
Indica el socket de tipo UNIX por donde se escuchará. Sólo sirve para comunicaciones entre
procesos de la misma máquina
Service = unNomAlternatiu
Si el nombre del archivo "service" no es igual que el nombre del archivo "socket", aquí se puede indicar
entonces el nombre que tiene el archivo "service" para que el socket el sepa encontrar.
Accept = yes
Si se indica, hace que se genere una instancia del servicio diferente para cada conexión. Útil cuando se
utilizan plantillas. Si su valor es no (por defecto) sólo una instancia del servicio
gestionará todas las conexiones.
El comando systemctl status * .socket nos permite saber cuántos y cuáles sockets están escuchando ahora
mismo; el valor "Accepted" muestra cuántas conexiones se han realizado en total desde que el socket ha sido
iniciado y el valor "Connected" muestra cuántas conexiones están actualmente activas
Como cualquier otra Unit, se pueden ver la lista de sockets con el comando s ystemctl list-Units -t
socket pero además disponemos del comando específica systemctl list-sockets , la cual informa de qué servicio
correspondiente activan y en qué puerto / socket UNIX escuchan.
EJERCICIOS:
1.-a) Crea el fichero "/etc/systemd/system/dateserver.socket" con el siguiente contenido:
[Unido]
Description = Servicio de fecha en el puerto 55555
[Socket]
ListenStream = 55555
Accept = true
[Install]
WantedBy = sockets.target
b) Crear el fichero "/etc/systemd/system/dateserver@.service" con el siguiente contenido:
[Unido]
Description = Servicio de fecha
[Service]
Type = simple
ExecStart = / opt / dateserver.sh
StandardOutput = socket
StandardError = journal
c) Crear el fichero "/opt/dateserver.sh" con el siguiente contenido (y dale permisos de ejecución!):
#! / Bin / bash
while [[true]]
do
Page 23
# Atención: comprueba que date se encuentre dentro de / usr / bin; dependiendo de la distribución eso cambia
/ Usr / bin / date
sleep 1
dé
d) Abre un terminal y ejecuta el comando nc ipServidor 55555 . ¿Qué ves? Abre otro terminal diferente y
ejecuta el mismo comando. ¿Qué ves? ¿Qué te muestra el comando systemctl status dateserver.socket ? ¿Y la
comando systemctl status dateserver @ * ? ¿Y el comando systemctl list-Units dateserver @ * ?
2.- Haz que el servidor SSH que tengas instal.lat a la máquina (si no lo tienes, instal.la'l) inicie sólo a través
de un socket. concretamente:
a) Crear el fichero "/etc/systemd/system/sshMitjo.socket" con el siguiente contenido:
[Unido]
Description = Mi SSH Socket
[Socket]
ListenStream = 22
Accept = yes
[Install]
WantedBy = sockets.target
b) Crear el fichero "/etc/systemd/system/sshMitjo@.service" con el siguiente contenido:
[Unido]
Description = Mi SSH Server
[Service]
Type = simple
ExecStart = - / usr / sbin / sshd -y
StandardInput = socket
StandardOutput = socket
NOTA: Aquí la clave está en la combinación del parámetro -y del binario sshd (el cual hace que habilitar la posibilidad de que pueda recibir
peticiones a través de sockets), y la directiva StandardInput (lo realiza de forma efectiva este tipo de comunicación entre el
socket y el servidor SSH)
NOTA: Importante is the "-" in front of the binary name. This ENSUR that the exit status of the para-connection sshd process is
forgotten by systemd. Normally, systemd will store the exit status of a all service instances that die abnormally. SSH will sometimes
die abnormally with an exit code of 1 oro similar, and we want to make sure that this does not cause systemd to keep around
information for numerous previous connections that died this way (until this information is forgotten with systemctl reset-failed).
c) Ejecutar el comando systemctl enable sshMitjo.socket y systemctl disable ssh.service (si fuera necesario) y reinicia
la máquina. Una vez hecho, comprueba que el socket sshMitjo esté funcionando pero no el servicio sshMitjo.
Ejecuta ssh usuario @ ipServidor para entrar en el servidor SSH (deberías de conseguir sin problemas) y
comprueba seguidamente que ahora sí está funcionando una instancia del servicio sshMitjo
d) ¿Qué haría un comando como systemctl killsshd@172.31.0.52 : 22-172.31.0.4: 47779.service?
Page 24
3.-a) En el ejercicio anterior hemos tenido la suerte de que el servidor SSH ofrece un parámetro (-y) que le permite
delegar la apertura de los sockets (puertos) a un "agente externo" como es systemd. Pero no siempre tendremos un
servidor que ofrezca esta posibilidad. En este sentido, lee los siguientes párrafos y resumen con las
tus propias palabras que explica:
One of the limitations of socket activación is that it requires the activated application to be aware that it may be socket-activated; the
process of accepting an existing socket is different from creating a listening socket from scratch. Consequently a lot of widely used
applications do not support it. The systemd developers have known that it may take some time to get activación apoyo everywhere, sonido
they Introduced "systemd-socket-proxyd", a small TCP and Unix domain socket proxy server. This does understand activación, and
will sit between the network and our server, transparently forwarding packets between the two. The steps to use this tool are:
Step 1: We create a socket that Listener on the puerto that will eventually be served by the proxy / server combination.
Step 2: On the first connection to the socket systemd activados the proxy service and hands it the socket.
Step 3: When the proxy is started the corresponding server is first Broughten up (thanks to the Requires / After dependency)
The proxy then shuttles all traffic between the server and the network. The only trick here is that we need to bind the server to a puerto
other than the real-target puerto (8080 instead of 80 if we are running a webserver, for instance). This is because that puerto will be
owned by the socket / proxy, and you can not bind two processes to the same socket and interface.
Step 1: "myserver-proxy.socket" file
[Socket]
ListenStream = 0.0.0.0: 80
[Install]
WantedBy = sockets.target
Step 2: "myserver-proxy.service" file
[Unido]
Requires = myserver.service
After = myserver.service
[Service]
ExecStart = / usr / lib / systemd / systemd-socket-proxyd 127.0.0.1:8080
Step 3: "myserver.service" file
[Unido]
Description = Server example (replace ExecStart value with something more realistic)
[Service]
#We listening server s listening puerto only to loopback interface because it 's there where input packages comas from proxy
ExecStart = / usr / bin / ncat -k -l 127.0.0.1 8080
