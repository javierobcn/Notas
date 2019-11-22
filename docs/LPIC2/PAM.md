#PAM



##Introducción

Existen muchas maneras de autenticar usuarios: consultando los logins / passwords locales en la pareja de archivos `/etc/passwd` y `/etc/shadow`, o bien consultando en un servidor LDAP, o en una base de datos relacional convencional , o bien a través de tarjetas hardware, o vía reconocimiento de huellas dactilares, etc. Esto para los desarrolladores es un problema, porque para que sus programas (como login, gdm, sudo, su, ftp, nfs, ssh, ...) soporten todos estos diferentes métodos de autenticación, deben programar explícitamente cada método por separado (además de que si apareciera otro método nuevo, debería de recompilarse el programa para que se soportara -en el caso de que fuera posible - o bien reescribir de nuevo el programa completo. 

PAM es un conjunto de librerías (básicamente `libpam.so` pero no sólo esa) que hacen de intermediarias entre los métodos de autenticación y los programas que los usan, permitiendo la posibilidad de desarrollar programas de forma independendiente del esquema de autenticación que se utiliza. La idea es que un programa, gracias a que haya sido desarrollado mediante las librerías PAM, pueda utilizar un/os determinado/s módulo/s binarios (o un /os otro/s, según le interese) que se encargue/n del "trabajo sucio" de autenticación. El / los módulo/s concreto/s que utilizará el programa en un determinado momento lo/s escogerá el administrador del sistema, el cual podrá cambiar de módulo/s (de /etc/shadow a LDAP por ejemplo), si así lo deseara, sin que el programa correspondiente notara la diferencia. Resumiendo PAM facilita la vida a los desarrolladores para que en vez de escribir una compleja capa de autenticación para sus programas simplemente tienen que escribir un "hook" en PAM, y también facilita la vida a los administradores porque pueden configurar la autenticación de los programas que la necesitan de una forma centralizada y común sin necesidad de recordar cada modelo separado para cada programa.

##Archivos relacionados con PAM
1. **Los módulos**, ubicados en `/usr/lib64/security`  (Fedora 31) o `/lib/x64_64-linux-gnu/security` (en Ubuntu) o `/lib/x86_64-linux-gnu/security/` Mint 18. Muchos se instalan "de serie"junto con las librerías PAM pero también pueden ser "de terceros". En cualquier caso, cada módulo implementa un método de autenticación diferente y básicamente puede devolver dos valores: "éxito" (PAM_SUCCESS) o "fallo" (PAM_PERM_DENIED u otros equivalentes).

    !!!NOTE "Nota"
        En Ubuntu estos módulos -y muchos otros- se encuentran dentro del paquete `libpam-modules` "(instalado por defecto en el sistema). En Fedora se encuentran en el paquete `pam` (también instalado por defecto)

    !!!NOTE "Nota"
        Algunos de los módulos oficiales más importantes son los siguientes (consultar http://www.linux-pam.org/Linux-PAM-html/sag-module-reference.html
        o bien la página del manual "pam_xxx "para saber más): 

2. **Los ficheros de configuración de los módulos** anteriores (si es que tienen), ubicados en `/etc/security`

3. **Los ficheros de configuración proporcionados por cada aplicación**, encargados de establecer qué métodos de autenticación utilizará esta. Son archivos de texto que tienen como nombre el nombre de la aplicación asociada y están ubicados dentro del directorio `/etc/pam.d`.

##Módulos
|Módulo|Función|
|------|-------|
|**pam_unix.so**|Realiza la autenticación mediante el método tradicional (`/etc/passwd` y `/etc/shadow`). Si se quiere realizar la autenticación contra usuarios / contraseñas guardados en bases de datos BerkeleyDB se puede usar entonces el módulo **pam_userdb.so**
|**pam_deny.so**|Siempre devuelve fallo. Generalmente se ejecuta si ningún otro módulo ha tenido éxito|
|**pam_permit.so**|Siempre devuelve éxito (por lo tanto, no hay autenticación, usándose entonces el usuario nobody)|
|**pam_cracklib.so**|Solo es un módulo de tipo "password" (ver más abajo). Se asegura de que la contraseña empleada tenga un nivel de seguridad suficiente según las reglas establecidas (longitud, variabilidad, etc). Hay otro módulo similar llamado **pam_pwquality.so** algo más moderno (pero no viene dentro del paquete "oficial"). Otro es **pam_passwdqc.so** (programado por la gente del John The Ripper)|
|**pam_pwhistory.so**|comprueba que, al cambiar una contraseña, no haya sido usada antes alguna vez 
|**pam_succeed_if.so**|Da por válida una autenticación (o no) según el valor de una o más características especificadas (uid, nombre, ruta de carpeta personal, shell por defecto, grupo al que pertenece...) que tenga la cuenta de usuario autenticado|
|**pam_access.so**|Da por válida una autenticación (o no) según si un/os determinado/s usuario/s o grupo/s accede desde un/os determinado/s terminal/es local/es o bien determinada/s máquina/s remota/s -Comprobandor su nombre o su IP. Un módulo que implementa unafuncionalitat similar (aunque se configura diferente) es pam_listfile.so|
|**pam_time.so**|Da por válida una autenticación (o no) según el momento (hora, día ...) en que se hace|
|**pam_faillock.so**|Cuenta el nº seguidos de intentos de autenticación fallidos durante un cierto periodo de tiempo con el objetivo de bloquear el acceso. Antiguamente había otro módulo similar llamado "pam_tally2" que ha sido retirado por obsoleto (https://src.fedoraproject.org/rpms/pam/blob/f30/f/pam.spec#_398)|
|**pam_lastlog.so**|Bloquea el logueig de un usuario dependiendo de la fecha de su último login|
|**pam_faildelay.so**|Establece el tiempo de espera mínimo entre introducciones seguidas de contrasenyes erroneas (menos del cual siempre devolverá "fallo" sea cual sea la contr. escrita)|
|**pam_limits.so**|Solo es un módulo de sesión (ver más abajo). Asigna determinadas limitaciones a los usuarios (nº máximo de procesos permitidos, nº máximo de archivos abiertos, etc), según la configuració indicada en el archivo `/etc/security/limits.conf`. Actualmente, sin embargo, esta funcionalidad también viene incorporada dentro de systemd (ver las directivas "LimitXXX" a mano systemd.exec) así que todos los servicios gestionados por systemd no usan este módulo para nada.|
|**pam_securetty.so**|Excepto en los terminales listados en el archivo `/etc/securetty`, prohíbe la autenticación al root. Si este archivo no existe, se permitirá la autenticación de root desde cualquier terminal|
|**pam_nologin.so**|Si existe el archivo `/etc/nologin` (cuyo contenido se mostrará en pantalla) , prohibe la autenticación de todos excepto root|
|**pam_wheel.so**|solo permite actuar como root (mediante su/sudo) a los usuarios del grupo "wheel"|
|**pam_rootok.so**|Permite que el usuario "root" se pueda autenticar de forma directa (es decir, sin que se le pida ningún tipo de autenticación)
|**pam_env.so**|Permite utilizar variables de entorno definidas dentro de `/etc/security/pam_env.conf` (o archivo indicado con "envfile =") y que pueden ser utilizadas por otros módulos posteriores o también por el sistema.|
|**pam_echo.so**|Muestra mensajes personalizados por pantalla|
|**pam_motd.so**|Muestra un mensaje (por defecto el incluido en /etc/motd) una vez el usuario ha logueado. Muchas veces, sin embargo, para hacer esto se usa directamente el archivo `/etc/profile` o similar|
|**pam_exec.so**|Ejecuta un comando externo|
|**pam_mkhomedir.so**|Crea la carpeta personal de un usuario cuando se loguea por primera vez en el sistema. Útil para cuando el usuario no es local sino que se encuentra en alguna BD remota o serv. LDAP|
**pam_systemd.so**|Només es un módulo de sesión (ver más abajo). Apoya el servicio systemd-login|

También existen otros módulos no oficiales pero muy interesantes que se pueden instalar como paquetes estándar (para encontrar estos y muchos otros, puede ejecutar `apt search libpam` -Ubuntu- o bien `dnf search pam` -en Fedora -): 

|Módulo|Función|
|------|-------|
|**pam_captcha.so**| Muestra un texto gráfico mediante figlet a modo de captcha. Su página oficial es https://github.com/jordansissel/pam_captcha Atención: No está empaquetado en las distribuciones más importantes|
|**pam_oath.so**|Implementa sistema de autenticación con contraseñas de un solo uso (OTP). La página oficial es http://www.nongnu.org/oath-toolkit |
|**pam_google_authenticator.so**|Utilitza los servidores de Google para realizar el logueo en dos pasos (con contraseñas de un solo uso, las OTP). Su página oficial es https://github.com/google/google-authenticator-libpam |
|**pam_usb.so** *DEPRECATED*|Solo permite el inicio de sesión si hay un lápiz Usb enchufado en el ordenador. Su página oficial és https://github.com/aluzzardi/pam_usb |
|**pam_ldap.so**|Realiza la autenticación contra usuarios/contraseñas guardados en un servidor Ldap. La página oficial es http://www.padl.com/OSS/pam_ldap.html |
|**pam_mariadb.so**|Realiza la autenticación contra usuarios/contraseñas guardados en un servidor MariaDB.su pagina oficial es https://mariadb.com/kb/en/ |
|**pam_mysql.so**| Realiza la autenticación contra usuarios / contraseñas guardados en un servidor MySQL. Su página oficial es https://github.com/NigelCunningham/pam-MySQL. Por otra parte, decir que existe un módulo PAM de MySQL oficial, pero es comercial ( https://dev.mysql.com/doc/refman/5.7/en/pam-pluggable-authentication.html |
|**pam_pgsql.so**| Realiza el autentiació contra usuarios / contraseñas guardados en un servidor PostgreSQL. Su página es https://github.com/pam-pgsql/pam-pgsql |
|**pam_sqlite3.so**|Realiza el autentiació contra usuarios / contraseñas guardados en un servidor SQLite3. Su página oficial es https://github.com/HormyAJP/pam_sqlite3 |
|**pam_abl.so**|Bloquea nombres de usuario / IPs remotas que intentan loguearte al sistema (Similar en intención a fail2ban). Su página oficial es https://github.com/deksai/pam_abl |


!!!NOTE "Nota"
    NOTA: En el caso de querer desarrollar una aplicación propia (en C) que haga uso de alguno de los módulos anteriores y se aproveche de su funcionalidad, un pequeño tutorial lo podréis encontrar aquí:
    https://fedetask.com/writing-a-linux-pam-aware-application.
    En el caso de querer desarrollar un módulo PAM propiamente dicho, un pequeño tutorial lo podréis encontrar aquí: https://fedetask.com/write-linux-pam-module En cualquier caso, la guía oficial del desarrollador PAM se encuentra en http://www.linux-pam.org/Linux-PAM-html/inux-PAM_ADG.html y http://www.linux-pam.org/Linux-PAM-html/Linux-PAM_MWG.html , respectivamente.


##Archivos de configuración de las aplicaciones
En el punto 3. ya hemos dicho que dentro de `/etc/pam.d` encontramos los ficheros de configuración que controlan el comportamiento de las aplicaciones homónimas que utilizan los módulos PAM (login, gdm, ssh, sudo, ...).

Estos archivos constan de líneas formadas por tres campos (explicados a continuación), donde hay que tener en cuenta que el orden de las líneas es muy importante (se leen de arriba a abajo):

```
grupo_gestion  marca_control  módulo  [opciones]     
```

1. **Grupo de gestión**: PAM define cuatro tipos de grupos de gestión, cada uno de los cuales controla un aspecto de la seguridad o autenticación de cuentas. Se suelen ejecutar con el siguiente orden: "auth", luego "account" y luego "Session"; la acción "password" se ejecuta bajo demanda:
    *  **auth**: autentica al usuario. Es decir, comprueba si es un usuario válido y reconocido por el sistema y que tenga una contraseña (o el método de autenticación utilizado) igual a la proporcionada por la aplicación.
    *  **account**: autoriza al usuario. Es decir, una vez autenticado, le da acceso -o no- a ciertos recursos del sistema siguiendo las restricciones indicadas: nº màximo de usuarios, localización del usuario, horario, expiración de la contraseña, etc
    *  **password**: acción activada al actualizar contraseñas 
    *  **session**: aplica acciones sobre el usuario ya autorizado que están relacionadas con el inicio y final de sesión (como montar carpetas, utilizar el correo del sistema, habilitar los logs, ejecutar algún script, definir variables de entorno, crear carpetas personales, etc)

2.  **Marca de control**: Indica cómo debe reaccionar el módulo ante el éxito (valor devuelto PAM_SUCCESS) o el error (diferentes valores posibles dependiendo del tipo de error) en la autenticación. En concreto puede valer:

    * **requisite**: se necesita el éxito de este módulo. Si falla no se sigue leyendo (y se notifica Error); si se obtiene éxito, se siguen leyendo las siguientes líneas "requisite" correspondientes a la misma acción (valor 1er campo). En conclusión: sólo hay éxito si todos los módulos "requisite" de la misma acción han obtenido éxito
    *  **required**: igual que con requisite, se necesita el éxito de este módulo. La diferencia está en que tanto si se obtiene éxito como si falla, se sigue leyendo el resto de líneas "required" correspondientes al mismo grupo de gestión (valor 1er campo) y no se notifica a la aplicación el resultado final hasta leer la última de estas líneas. Esto se hace por seguridad, para que un "hacker" no sepa qué módulo ha fallado. En conclusión: **sólo hay éxito si todos los módulos "required" de la misma acción han obtenido éxito**
    *  **sufficient**: si su resultado es éxito (y los required / requisite anteriores también), no se sigue leyendo. Si falla, sí se sigue leyendo el resto de líneas correspondientes a la misma acción (valor 1er campo). En conclusión: hay éxito simplemente con que un solo módulo "sufficient" de una determinada acción haya obtenido éxito.
    *  **optional**: su valor de retorno (éxito o fallo) no influye en el éxito para que la autenticación / autorización / ... se efectúe. Simplemente ejecuta el módulo para realizar una determinada tarea y ya está. Este valor se suele utilizar con módulos de tipo "session".
    *  **include**: incluye el contenido de otro archivo, cuyo nombre se debe indicar al 3 r campo (y su ubicación será igualmente `/etc/pam.d`). Otro valor similar sería **substack**
    *  **[opcion1 = valor1 opcio2 = valor2]**: permite un control más granular de las condiciones de éxito y fracaso. Las "opciones" corresponden a los diferentes valores de retorno del módulo en cuestión y los "Valores" representan la acción que se ejecutará al detectar este retorno concreto. Por ejemplo, entre las "opciones" podemos tener: 
        *   **success**: el módulo devuelve PAM_SUCCESS
        *   **ignore**: el módulo dice que ignore cualquier línea "account" posterior
        *  **...** : Multitud de errores diferentes devueltos por el módulo (ver http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html) 
        *  **default**: cualquier valor de retorno no indicado explícitamente mediante una "opción" 
          
        Y entre los "valores" podemos tener:
        
        *  **Un nº**: indica el número de líneas dentro del archivo que se deberán saltar para continuar leyendo la configuración en la línea justo después del salto
        *  **bad**: indica que el módulo devolverá "fallo" en la aplicación y se continuará leyendo 
        *  **die**: indica que el módulo devolverá "fallo" en la aplicación y se dejará de leer
        *  **ok**: Indica que el módulo devolverá "éxito" en la aplicación y se continuará leyendo
        *  **done**: indica que el módulo devolverá "éxito" en la aplicación y se dejará de leer
        *  **ignore**: indica que la "opción" correspondiente no se tiene en cuenta (como si no hubiera pasado)
            
            !!!NOTE "Nota:"
                En este sentido, podemos concluir que las palabras "requisite", "required", "sufficient" y "optional" no son más que atajos de los siguientes valores, respectivamente:
                ```
                success=ok new_authok_reqd=ok default=die ignore=ignore
                success=ok new_authok_reqd=ok default=bad ignore=ignore
                success=done new_authok_reqd=done default=ignore
                success=ok new_authok_reqd=ok default=ignore
                ```
            !!!NOTE "NOTA:"
                La diferencia entre el valor "include" y el valor "substack" es que en este último el fichero "madre" ve las líneas incluidas en él como una única línea con un único resultado "éxito" o "falLO"

3.  **Módulo** : Nombre (o ruta absoluta si es diferente de /lib/security) del archivo correspondiente al módulo PAM utilizado, seguido de los posibles parámetros que puede recibir. En el caso de que el 2º campo sea la palabra
"Include", entonces será el nombre del archivo de configuración ubicado en `/etc/pam.d` cuyo contenido se quiere "copiar-pegar".

    !!!NOTE "NOTA:"
        Si se quiere saber qué aplicaciones utilizan un módulo PAM concreto, se puede ejecutar simplemente el comando `grep "NomModul" /etc/pam.d/*` 
           
    !!!NOTE "NOTA:"
        Si se quiere ver el contenido de alguno de estos archivos de configuración sin las líneas de comentarios ni las líneas vacías (es decir, sólo las líneas efectivas), un truco es ejecutar, en vez de cat o less, el comando `grep -vE "(^#|^$)" /etc/pam.d/nomFitxer`

    !!!NOTE "NOTA:"
        El archivo `/etc/pam.d/other` sirve para definir las directivas "auth", "account", "password" y "session" de cualquier aplicación que no incorpore ningún archivo de configuración PAM propio. Normalmente, este archivo lo deniega todo ... es recomendable su consulta.

Hay muchas aplicaciones que comparten el mismo esquema de autenticación. Las distribuciones más populares facilitan la tarea de administrar de forma centralizada estas aplicaciones (login, su, ssh ...) concentrando la configuración común en los archivos "common-auth", "common-account", "common-
password "," common-session "(Debian / Ubuntu) o" system-auth "y" assword-auth "(Fedora / Suse). Por lo tanto, muchas veces sólo habrá que modificar estos archivos para cambiar el modo de autenticación de muchas de las aplicaciones del sistema de golpe. Para saber qué aplicaciones utilizan estos archivos comunes (concretamente, por ejemplo el "common-auth") basta con hacer `grep common-auth /etc/pam.d/*` 

!!!NOTE "NOTA:"
    La diferencia entre los archivos "`system-auth`" y "`password-auth`" en Fedora / Suse es muy poca: de hecho, apenas hay una o dos líneas diferentes. En principio, el primer archivo está pensado para ser utilizado en autenticaciones locales (por su, sudo, etc) yel segundo está pensado para ser utilizado en autenticaciones remotas (por ssh, vsftpd, etc)

!!!NOTE "NOTA:"
    En Debian / Ubuntu también existe el archivo "`common-session-noninteractive`", el cual sirve a todas aquellas aplicaciones que no proporcionan interactividad (como cron, lagares, samba, ppp, etc)

!!!NOTE "NOTA:"
    Esta configuración común presente en los archivos "common- *" o "* -auth" (según sea Debian / Ubuntu o Fedora /Suse, respectivamente) se puede modificar mediante aplicaciones específicas que evitan el tener que editar directamente los archivos de texto. Concretamente, en Debian / Ubuntu esta aplicación se llama palmo-auth-config, a Fedora llama authselect y Suse llama pam-config. Sin embargo, no las estudiaremos.

Hay módulos que pueden utilizarse en los cuatro grupos de gestión del 1er campo y otros que sólo pueden utilizarse para algún valor determinado. En concreto tenemos que (esta información se puede obtener de la página de
manual de cada módulo):

* Los módulos de las listas anteriores que pueden usarse con los cuatro valores son:
    -  pam_unix, pam_listfile, pam_succeed_if, pam_permit / deny, pam_echo, pam_rootok, pam_exec
* Los módulos de las listas anteriores que pueden usarse sólo con los valores "auth" y "account" son:
    -  pam_userdb, pam_tally2, pam_lastlog, pam_nologin, pam_wheel
* Los módulos de las listas anteriores que pueden usarse sólo con los valores "auth" y "session" son:
    -  pam_env
* Los módulos de las listas anteriores que pueden usarse sólo con el valor "auth" son:
    -  pam_securetty, pam_faildelay, pam_captcha, pam_google_authenticator, pam_usb, pam_oath
* Los módulos de las listas anteriores que pueden usarse sólo con el valor "account" son:
    -  pam_time, pam_access
* Los módulos de las listas anteriores que pueden usarse sólo con el valor "session" son:
    -  pam_limits, pam_motd, pam_mkhomedir, pam_systemd
* Los módulos de las listas anteriores que pueden usarse sólo con el valor "password" son:
    - pam_pwquality, pam_pwhistory

Para más ayuda sobre PAM, ver `man pam` y `man pam.d`
