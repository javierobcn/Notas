#SELinux
##DAC vs MAC
Linux con seguridad mejorada (SELinux, https://github.com/SELinuxProject) es un módulo del núcleo que implementa un sistema de control de acceso obligatorio (MAC). Fue desarrollado como un reemplazo para el Control de acceso discrecional (DAC) que se incluye con la mayoría de las distribuciones de Linux. Si solo usa un sistema DAC (por ejemplo, el modelo de permisos estándar / ACL):

* Los administradores no tienen forma de controlar a los usuarios: un usuario podría establecer permisos legibles para todo el mundo en archivos confidenciales (como las claves ssh). Incluso podría hacer `chmod +rwx` en todo su directorio de inicio y nada le detendría. La misma razón puede extenderse a cualquier programa (tal vez troyano) ejecutado por ese usuario porque los procesos heredan los permisos del usuario. En resumen: un usuario normal puede otorgar (y restringir) el acceso a sus archivos de propiedad a otros usuarios y grupos o incluso cambiar el propietario del archivo, dejando expuestos los archivos críticos a cuentas que no necesitan este acceso. Es cierto que se podría restringir a este usuario el acceso a algunos archivos, pero eso es discrecional: no hay forma de que el administrador pueda aplicarlo a cada archivo individual en el sistema.

* El acceso a la raíz (o sudo) en un sistema DAC le da a la persona (quizás hackeada) o al (quizás troyano) permisos de programa para realizar lo deseado en una máquina. En esencia, hay dos niveles de privilegio (raíz y usuario), y no hay una manera fácil de aplicar un modelo de privilegios mínimos (las cárceles chroot no son una opción porque también son discrecionales).

Pero si está utilizando un sistema MAC, los usuarios no podrán evitar las reglas establecidas previamente por el administrador del sistema. Estas reglas definen lo que un usuario o proceso puede hacer, limitando cada proceso a su
dominio propio para que el proceso pueda interactuar solo con ciertos tipos de archivos y otros procesos permitidos o dominios. Esto evita que un hacker secuestre cualquier proceso para obtener acceso a todo el sistema. Esta restricción es implementada desde el nivel del núcleo: se aplica a medida que la política SELinux se carga en la memoria y, por lo tanto, el control de acceso se vuelve obligatorio.

En SELinux todo está denegado: sysadmin debe escribir una serie de políticas de excepciones para dar a cada elemento del sistema (un servicio, tipo de proceso o usuario) solo el acceso requerido para funcionar (a
archivos, puertos, tuberías, ...). Si un servicio, programa o usuario posteriormente intenta acceder o modificar un archivo o recurso que no es necesario para que funcione, entonces esto se niega y se registra la acción.

Por ejemplo, el usuario de Apache solo puede acceder al directorio /var/www/html y nada más porque hay una política SELinux que manda eso. No hay acceso por defecto, incluso si usted es el usuario root. Debido a que SELinux se implementa dentro del núcleo, no es necesario que las aplicaciones ndividuales sean especialmente escritas o modificadas para trabajar bajo SELinux aunque, por supuesto, si está escrito para observar el error y los códigos que devuelve SELinux podrían funcionar mejor después. Si SELinux bloquea una acción, esto se informa a la aplicación subyacente como un error de tipo normal (o, al menos, convencional) de "acceso denegado" a la solicitud.

La política de SELinux no es algo que reemplace la seguridad tradicional de DAC. Si una regla DAC prohíbe un acceso de usuario a un archivo, las reglas de política de SELinux no se evaluarán porque la primera línea de defensa ya
ha bloqueado el acceso. Las decisiones de seguridad de SELinux entran en juego después de que se haya evaluado la seguridad de DAC. Así que si se deniega el acceso a un recurso, primero verifique los permisos comunes de acceso. Pero tenga en cuenta que si el DAC y el MAC entran en conflicto, La política de SELinux tiene prioridad. Entonces, supongamos que cambia, como root, la propiedad del servicio httpd a cualquiera (ejecutando el comando chmod 777 httpd); la política predeterminada de SELinux todavía evita cualquier intento de un usuario de matar el servidor web.

Una gran introducción a SELinux es https://wiki.gentoo.org/wiki/SELinux/Quick_introduction y, en general, https://wiki.gentoo.org/wiki/SELinux sitio completo.

##Activación de SELinux
SELinux tiene dos modos de funcionamiento: **permisivo** y **obligatorio**. El modo permisivo permite que el sistema funcione mediante el uso de sus sistemas DAC regulares mientras registra cada violación a SELinux. El modo obligatorio impone una estricta denegación de acceso a cualquier cosa que no esté explícitamente permitida por las políticas de SELinux. Puedes ver
en que modo se está ejecutando SELinux con el comando `getenforce`.

Otro comando que se puede usar para saber lo mismo (aunque muestra otros datos informativos) es

`sestatus`

!!!NOTE "Nota"
    NOTA: El significado de la información mostrada por este comando, entre otros argumentos interesantes, se explica en https://www.thegeekstuff.com/2017/06/selinux-sestatus/

Puede cambiar inmediatamente al modo deseado simplemente ejecutando
`sudo setenforce permisivo (o sudo setenforce enforcing)`

Si desea que este cambio sea permanente, debe modificar el archivo `/etc/selinux/config` (que es enlazado por `/etc/sysconfig/selinux`). Específicamente deberías tener esta línea ...

    SELINUX=permissive (o SELINUX=enforcing)


... y luego reiniciar el sistema.

Por diseño, SELinux permite escribir diferentes políticas que son intercambiables editando el SELINUXTYPE = línea en el archivo "/etc/sysconfig/selinux". La política predeterminada es la política "targeted" que limita los procesos del sistema seleccionados previamente. Por defecto, muchos procesos del sistema ya están seleccionados y "dirigidos" desde su instalación (incluidos httpd, named, dhcpd, mysqld, etc.) pero todos los otros procesos del sistema y todos los programas de espacio de usuario restantes se ejecutan en un dominio no confinado y no cubierto por el modelo de protección SELinux. Un objetivo podría ser apuntar a cada proceso para obligarlos a ejecutarse en un dominio confinado para que la política "targeted" proteja tantos procesos clave como sea posible, pero es responsabilidad de los mantenedores de paquetes. La alternativa sería un modelo de denegación por defecto donde cada
acceso es denegado a menos que lo apruebe la política: sería una implementación muy segura, pero esto también significa que los desarrolladores tienen que anticipar todos los permisos posibles que cada proceso puede necesitar en cada único objeto posible. Entonces, en resumen, el comportamiento predeterminado hace que SELinux se preocupe solo por ciertos
procesos.

La política SELinux "targeted" se proporciona con 4 formas de control de acceso:
* Type Enforcement (TE): Type Enforcement es el mecanismo principal de control de acceso utilizado en la política dirigida
* Control de acceso basado en roles (RBAC): basado en usuarios de SELinux (no necesariamente el mismo que el
Usuario de Linux), pero no se utiliza en la configuración predeterminada de la política de destino
* Seguridad multinivel (MLS): no se usa comúnmente y a menudo se oculta en la política de destino predeterminada.
* Seguridad multicategoría (MCS): una extensión de seguridad multinivel, utilizada en la política específica
para implementar la compartimentación de máquinas virtuales y contenedores a través de sVirt.
Enviar comentarios
Historial
Guardadas
Comunidad