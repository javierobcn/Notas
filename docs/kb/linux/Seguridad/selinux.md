#SELinux
##DAC vs MAC
Linux con seguridad mejorada (SELinux, https://github.com/SELinuxProject) es un módulo del núcleo que implementa un sistema de control de acceso obligatorio (MAC). Fue desarrollado como un reemplazo para el Control de acceso discrecional (DAC) que se incluye con la mayoría de las distribuciones de Linux. Si solo usa un sistema DAC (por ejemplo, el modelo de permisos estándar / ACL):

* Los administradores no tienen forma de controlar a los usuarios: un usuario podría establecer permisos legibles para todo el mundo en archivos confidenciales (como las claves ssh). Incluso podría hacer `chmod +rwx` en todo su directorio de inicio y nada le detendría. La misma razón puede extenderse a cualquier programa (tal vez troyano) ejecutado por ese usuario porque los procesos heredan los permisos del usuario. En resumen: un usuario normal puede otorgar (y restringir) el acceso a sus archivos de propiedad a otros usuarios y grupos o incluso cambiar el propietario del archivo, dejando expuestos los archivos críticos a cuentas que no necesitan este acceso. Es cierto que se podría restringir a este usuario el acceso a algunos archivos, pero eso es discrecional: no hay forma de que el administrador pueda aplicarlo a cada archivo individual en el sistema.

* El acceso a la raíz (o sudo) en un sistema DAC le da a la persona (quizás hackeada) o al programa (quizás troyanizado) permisos para realizar lo deseado en una máquina. En esencia, hay dos niveles de privilegio (raíz y usuario), y no hay una manera fácil de aplicar un modelo de privilegios mínimos (las jaulas chroot no son una opción porque también son discrecionales).

Pero si está utilizando un sistema MAC, los usuarios no podrán evitar las reglas establecidas previamente por el administrador del sistema. Estas reglas definen lo que un usuario o proceso puede hacer, limitando cada proceso a su
dominio propio para que el proceso pueda interactuar solo con ciertos tipos de archivos y otros procesos permitidos o dominios. Esto evita que un hacker secuestre cualquier proceso para obtener acceso a todo el sistema. Esta restricción es implementada desde el nivel del núcleo: se aplica a medida que la política SELinux se carga en la memoria y, por lo tanto, el control de acceso se vuelve obligatorio.

En SELinux todo está denegado: el sysadmin debe escribir una serie de políticas de excepciones para dar a cada elemento del sistema (un servicio, tipo de proceso o usuario) solo el acceso requerido para funcionar (a
archivos, puertos, tuberías, ...). Si un servicio, programa o usuario posteriormente intenta acceder o modificar un archivo o recurso que no es necesario funcionalmente, entonces se deniega el acceso y se registra la acción.

Por ejemplo, el usuario de Apache solo puede acceder al directorio `/var/www/html` y nada más porque hay una política SELinux que manda eso. No hay acceso por defecto, incluso si usted es el usuario root. Debido a que SELinux se implementa dentro del núcleo, no es necesario que las aplicaciones individuales sean especialmente desarrolladas para trabajar bajo SELinux aunque, por supuesto, si se desarrollan para observar el error y los códigos que devuelve SELinux podrían funcionar mejor. Si SELinux bloquea una acción, la aplicación subyacente es informada con un un error de tipo normal (o, al menos, convencional) de "acceso denegado" a la solicitud.

Una gran introducción a SELinux es https://wiki.gentoo.org/wiki/SELinux/Quick_introduction y, en general, https://wiki.gentoo.org/wiki/SELinux sitio completo.

##Activación de SELinux
SELinux tiene dos modos de funcionamiento: **permisivo** y **obligatorio**. El modo permisivo permite que el sistema funcione mediante el uso de sus sistemas DAC regulares mientras registra cada violación a SELinux. El modo obligatorio impone una estricta denegación de acceso a cualquier cosa que no esté explícitamente permitida por las políticas de SELinux. Puedes ver
en que modo se está ejecutando SELinux con el comando `getenforce`.

Otro comando que se puede usar para saber lo mismo (aunque muestra otros datos informativos) es

`sestatus`

!!!NOTE "Nota"
    NOTA: El significado de la información mostrada por este comando, entre otros argumentos interesantes, se explica en https://www.thegeekstuff.com/2017/06/selinux-sestatus/

Puede cambiar inmediatamente al modo deseado simplemente ejecutando
`sudo setenforce permisive (o sudo setenforce enforcing)`

Si desea que este cambio sea permanente, debe modificar el archivo `/etc/selinux/config` (que es enlazado por `/etc/sysconfig/selinux`). Específicamente deberías tener esta línea ...

    SELINUX=permissive (o SELINUX=enforcing)


... y luego reiniciar el sistema.

Por diseño, SELinux permite escribir diferentes políticas que son intercambiables editando la línea `SELINUXTYPE =` en el archivo `/etc/sysconfig/selinux`. La política predeterminada es la política "targeted" que confina procesos del sistema preseleccionados. Por defecto, muchos procesos del sistema ya están preseleccionados y "dirigidos" por SELinux desde su instalación (incluidos httpd, named, dhcpd, mysqld, etc.) pero todos los otros procesos del sistema y todos los programas de espacio de usuario restantes se ejecutan en un dominio no confinado y no quedan cubiertos por el modelo de protección SELinux. Un objetivo podría ser apuntar a cada proceso para obligarlos a ejecutarse en un dominio confinado para que la política "targeted" proteja tantos procesos clave como sea posible, pero eso es responsabilidad de los mantenedores de paquetes. La alternativa sería un modelo de denegación por defecto donde cada acceso es denegado a menos que lo apruebe la política: sería una implementación muy segura, pero esto también significa que los desarrolladores tienen que anticipar todos los permisos posibles que cada proceso puede necesitar en cada único objeto posible. Entonces, en resumen, el comportamiento predeterminado hace que SELinux se ocupe solo de ciertos procesos.

La política SELinux "targeted" se proporciona con 4 formas de control de acceso:

* **Type Enforcement (TE)**: Type Enforcement es el mecanismo principal de control de acceso utilizado en la política dirigida
* **Role-Based Access Control (RBAC)**: Control de acceso basado en roles, basado en usuarios de SELinux (no necesariamente el mismo que el Usuario de Linux), pero no se utiliza en la configuración predeterminada de la política de destino
* **Multi-Level Security (MLS)**:Seguridad multinivel, no se usa comúnmente y a menudo se oculta en la política de destino predeterminada.
* **Multi-Category Security (MCS)**:Seguridad multicategoría, una extensión de seguridad multinivel, utilizada en la política específica para implementar la compartimentación de máquinas virtuales y contenedores a través de sVirt.

##Conceptos básicos de SELinux
###Política
La política de SELinux no es algo que reemplace la seguridad tradicional de DAC. Si una regla DAC prohíbe un acceso de usuario a un archivo, las reglas de política de SELinux no se evaluarán porque la primera línea de defensa ya
ha bloqueado el acceso. Las decisiones de seguridad de SELinux entran en juego después de que se haya evaluado la seguridad de DAC. Así que si se deniega el acceso a un recurso, primero verifique los permisos comunes de acceso. Pero tenga en cuenta que si el DAC y el MAC entran en conflicto, La política de SELinux tiene prioridad. Entonces, supongamos que cambia, como root, la propiedad del servicio `httpd` a cualquiera (ejecutando el comando `chmod 777 httpd`); la política predeterminada de SELinux todavía evita cualquier intento de un usuario de matar el servidor web.

Una política de SELinux define el acceso de los usuarios a los roles, el acceso de los roles a los dominios y el acceso de los dominios a los tipos. Primero, el usuario tiene que estar autorizado para acceder a un rol, y luego el rol tiene que estar autorizado para acceder al dominio. El dominio a su vez está restringido para acceder solo a ciertos tipos de archivos:
###Usuarios y Roles
* SELinux tiene un conjunto de usuarios preconstruidos. Cada cuenta de usuario normal de Linux se asigna a uno o más Usuarios de SELinux.
* Un rol solo se usa cuando SELinux está configurado para implementar RBAC (por lo que no se usa de manera predeterminada). Un rol es un filtro: define qué usuarios pueden asumir el rol en cuestión y qué dominio puede desempeñar este rol

###Dominio
* Un dominio es el contexto dentro del cual se puede ejecutar un proceso SELinux. Ese contexto es como una envoltura alrededor del proceso: le dice al proceso lo que puede y no puede hacer. Por ejemplo, el dominio definirá
qué archivos, directorios, enlaces, dispositivos o puertos son accesibles para el proceso.

###Tipo
* Un tipo es el contexto de un archivo que estipula el propósito del archivo. Por ejemplo, el contexto de un archivo puede dictar que es una página web, o que el archivo pertenece al directorio `/etc`, o que el propietario del archivo
es un usuario específico de SELinux.

La política en sí es un conjunto de reglas que dicen que este usuario y este usuario solo pueden asumir este rol y este rol, y esos roles están autorizados para acceder solo a este y este dominio. Los dominios a su vez solo pueden acceder a determinados tipos de archivos.

!!! quote "Consejo de terminología"
    En general, cuando llamamos a algo como "sujeto" de SELinux nos referiremos a un proceso que puede potencialmente afectar un objeto. Un "objeto" de SELinux es cualquier cosa sobre la que se pueda actuar: puede ser un archivo, un directorio, un puerto, un zócalo tcp, el cursor o quizás un servidor X. Las acciones que un sujeto puede realizar en un objeto son las del sujeto

!!! quote "Consejo de terminología"
    el último paso, donde un proceso que se ejecuta dentro de un dominio particular solo puede realizar ciertas operaciones en ciertos tipos de objetos, se llama Type Enforcement (TE).

## Parámetros -Z 
Como acabamos de decir, el modelo primario o cumplimiento de SELinux se llama "Type Enforcement". Básicamente, esto significa que definimos una "etiqueta" en un proceso en función de su tipo, y una "etiqueta" en un objeto del sistema de archivos basado en su tipo, también. Las reglas de política controlan el acceso entre los sujetos etiquetados (procesos, demonios) y objetos etiquetados (carpetas, archivos, dispositivos, puertos ...) -o más específicamente, controlan qué usuarios pueden obtener qué roles y cada rol específico impone una restricción sobre a qué tipo de archivos puede acceder el usuario.

Estas etiquetas (algunas veces llamadas "contextos" también) se almacenan como atributos extendidos en el sistema de archivos o, para objetos que no son archivos (como procesos y puertos) son administrados por el núcleo. El formato de la etiqueta es:

    usuario: rol: tipo: sensibilidad

Veamos la etiqueta o contexto de un archivo, por ejemplo, del archivo `/etc/fstab` usando el parámetro **-Z** del comando [ls]:
    
    ls -lZ /etc/fstab
    -rw-rw-r--. 1 root root system_u:object_r:etc_t:s0 709 oct 29 18:02 /etc/fstab

Además de los permisos y propiedad de archivos estándar, podemos ver el contexto de seguridad de SELinux campos: `system_u: object_r: etc_t: s0`. Como puede ver, los usuarios de SELinux tienen el sufijo `_u`, los roles tienen el sufijo `_r` y los tipos (para archivos) o dominios (para procesos) tienen el sufijo `_t`.

!!! note "Nota"
    El modificador **-Z** funcionará con la mayoría de las utilidades para mostrar los contextos de seguridad de SELinux (`ps -eZ`, `id -Z`, `cp -Z`, `mkdir -Z`, `ss -Z`) * Cada cuenta de usuario de Linux se asigna a un usuario de SELinux, y en en este caso, el usuario root que posee el archivo se asigna al usuario system_u SELinux. Esta asignación se realiza mediante la política SELinux.

* La segunda parte especifica el rol SELinux, que es object_r. Hablamos de roles luego
* Lo más importante aquí es la tercera parte, el tipo de archivo que se muestra aquí como `etc_t`. Esta es la parte que define a qué tipo pertenece el archivo o directorio. Podemos ver que la mayoría de los archivos en el directorio `/etc` pertenecen a `etc_t`. También podemos ver que algunos archivos pueden pertenecer a otros tipos, como `locale.conf` que tiene un tipo `locale_t`. Incluso cuando todos los archivos enumerados aquí tienen los mismos usuarios y propietarios de grupos, Sus tipos podrían ser diferentes.
* La cuarta parte del contexto de seguridad, `s0`, tiene que ver con la seguridad multinivel o MLS. Básicamente esto es otra forma de hacer cumplir la política de seguridad de SELinux diferente de la "dirigida", y esta parte
muestra la sensibilidad del recurso (`s0`). No hablaremos de esto porque es un tema muy avanzado.

Si observamos el contexto de seguridad SELinux de un archivo en nuestro directorio de inicio, veremos algo así como esto: 

    unconfined_u: object_r: user_home_t: s0
 
 Por lo que podemos inferir que el tipo `user_home_t` es el tipo predeterminado para archivos en el directorio de inicio de un usuario.

También podemos ver la etiqueta de un binario (no en ejecución): si hacemos `ls -lZ /bin/ssh`, veremos que su contexto es `system_u: object_r: ssh_exec_t: s0`

El usuario, el rol y la sensibilidad funcionan tanto para archivos como para procesos. Sin embargo, el dominio es exclusivo para los procesos. Un dominio le da al proceso un contexto para ejecutarse: es como una burbuja alrededor del proceso que lo limita. Este confinamiento asegura que cada dominio de proceso solo pueda actuar sobre ciertos tipos de archivos y nada más. Usando este modelo, incluso si un proceso es secuestrado por otro  proceso malicioso o usuario, lo peor que puede hacer es dañar los archivos a los que tiene acceso. 

Si quieres conocer el contexto de seguridad SELinux de un proceso; por ejemplo, el demonio journald (`systemd-journal`), podría hacer ...:
    
    :::bash
    # Probado En Fedora 31
    ps -eZ | grep "systemd-journal"
    system_u:system_r:syslogd_t:s0      469 ?        00:00:00 systemd-journal

... y verá que los campos de contexto de SELinux ahora son:

    system_u: system_r: syslogd_t: s0

por lo que sus dominios son `syslogd_t`.

El acceso solo se permite entre dominios y tipos similares: un proceso que se ejecuta en el contexto httpd_t, por ejemplo, puede interactuar con un objeto con la etiqueta httpd_something_t. Entonces, cuando Apache se ejecuta en el dominio "httpd_t"  puede leer "/var/www/html/index.html" porque es del tipo "httpd_sys_content_t" pero no puede acceder a "/home/username/myfile.txt" aunque este archivo sea legible porque El contexto de seguridad de SELinux del archivo "/home/username/myfile.txt"  no es del tipo "httpd_t". Si Apache fuera a ser explotado, suponiendo por el bien de este ejemplo que el derecho de la cuenta raíz necesitaba efectuar un reinicio de SELinux no se obtuvo el etiquetado en otro contexto, no podría iniciar ningún proceso que no esté en httpd_t dominio (que evita la escalada de privilegios) o acceder a cualquier archivo que no esté en un dominio relacionado con httpd_t.

A menos que lo especifique la política, los procesos y archivos se crean con los contextos de sus padres. Así que si tenemos un proceso llamado "proc_a" que genera otro proceso llamado "proc_b", el proceso generado se ejecutará
en el mismo dominio que "proc_a" a menos que la política de SELinux especifique lo contrario. Del mismo modo, si tenemos un directorio con un tipo de "some_context_t", cualquier archivo o directorio creado debajo tendrá el mismo tipo contexto a menos que la política diga lo contrario. Esta herencia no se conserva cuando los archivos se copian a otro ubicación. En una operación de copia, el archivo o directorio copiado asumirá el contexto de tipo de la ubicación de destino Este cambio de contexto puede ser anulado por la cláusula --preserver = context en el comando cp. (disponible
del paquete "setools-console")

##Comandos Básicos SELinux
###semanage
Podemos usar ‘semanage’ para cambiar el contexto de un archivo / directorio (de manera similar a cómo 'chown' o 'chmod' puede usarse para cambiar la propiedad o los permisos de archivo estándar de un archivo). Por ejemplo, para cambiar el contexto de `/home/dan/html`, ejecute los siguientes comandos:

    sudo semanage fcontext -a -t httpd_sys_content_t ‘/home/dan/html(/.*)?’

!!!note "Nota"
    si no conoce la etiqueta pero conoce un archivo con la etiqueta equivalente que desea, puede hacer: 

        `sudo semanage fcontext -a -e /ruta/archivo1/ruta/archivo2`

Para verificar el contexto de seguridad de todos los archivos / directorios en el sistema de archivos podemos ejecutar:

    sudo semanage fcontext -l

###chcon
Sin embargo, otro comando que se puede usar para hacer lo mismo (es decir: cambiar el contexto de un archivo o archivos / directorios (opcionalmente recursivamente con el parámetro -R) es `chcon`:

    sudo chcon -vR -t httpd_sys_content_t / home / dan / html

!!!note "Nota"
    NOTA: Si no conoce la etiqueta pero conoce un archivo con el etiquetado equivalente que desea, puede hacer lo siguiente: 

        sudo chcon -referencia /ruta/archivo1 /ruta/archivo2

!!!note "Nota"
    NOTA: Puede cambiar todo el contexto simplemente haciendo 

        chcon user:role:type:sensibilidad /ruta/archivo 

o cualquier otra parte de el contexto con -los argumentos -u, -r o -l , respectivamente.

La modificación de los contextos de seguridad de ambas maneras (a través de `semanage fcontext -a` o `chcon`) persistirá entre reinicios del sistema pero en caso de haber ejecutado el cambio a través de `chcon`, durará solo hasta que
la porción modificada del sistema de archivos se vuelve a etiquetar. Si desea que un cambio de contexto sea permanente, incluso después de que un sistema de archivos completo se vuelve a etiquetar, debe usar `semanage fcontext -a`. Eso es porque este último escribe una regla personalizada local (un denominado Módulo de políticas) en `/etc/selinux/targeted/contexts/files/file_contexts.local` para que pueda "recordar" más tarde, si es necesario volver a aplicarlo.

###restorecon
El comando `restorecon` se puede usar para restaurar los contextos de seguridad SELinux predeterminados de los archivos 

Usemos Apache como ejemplo: supongamos que un usuario edita una copia de index.html en su directorio de inicio y mueve (`mv`) el archivo a DocumentRoot `/var/www/html` (que tiene un contexto diferente por defecto:
"Httpd_sys_content_t"). Mientras que el comando copy (`cp`) generalmente hará que el archivo adopte el contexto de seguridad del directorio de destino, move (`mv`) mantendrá el contexto de seguridad de la fuente. Entonces Apache no podrá cargar este archivo porque no tendrá la etiqueta correcta. Podríamos usar el comando `chcon` para cambiar el contexto de seguridad de los archivos en cuestión, pero como los archivos ahora están en el Apache DocumentRoot predeterminado (`/var/www/html`) solo debemos restaurar los contextos de seguridad predeterminados para ese directorio o archivo (s). 

De hecho, ejecutar [chcon] requiere que sepas el contexto correcto para el archivo, pero `restorecon` no necesita esto especificado. para
restaurar solo el archivo index.html, usaríamos ...:

    sudo restorecon -v /var/www/html/index.html

... o para restaurar recursivamente los contextos de seguridad predeterminados 
para todo el directorio:

    sudo restorecon -Rv / var / www / html

Como dijimos, el sistema sabe qué contexto aplicar cuando ejecuta `restorecon` porque SELinux "Recuerda" el contexto de cada archivo o directorio: se enumeran los contextos de archivos que ya existen en el sistema
en el archivo `/etc/selinux/targeted/contexts/files/file_contexts`. Es un archivo grande y enumera cada tipo de archivo asociado con cada aplicación y su contexto

[ls]: /../LPIC1/command%20line/#ls
[chcon]: #chcon