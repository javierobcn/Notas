#PAM



##Introducción

Existen muchas maneras de autenticar usuarios: consultando los logins / passwords locales en la pareja de archivos `/etc/passwd` y `/etc/shadow`, o bien consultando en un servidor LDAP, o en una base de datos relacional convencional , o bien a través de tarjetas hardware, o vía reconocimiento de huellas dactilares, etc. Esto para los desarrolladores es un problema, porque para que sus programas (como login, gdm, sudo, su, ftp, nfs, ssh, ...) soporten todos estos diferentes métodos de autenticación, deben programar explícitamente cada método por separado (además de que si apareciera otro método nuevo, debería de recompilarse el programa para que se soportara -en el caso de que fuera posible - o bien reescribir de nuevo el programa completo. 

PAM es un conjunto de librerías (básicamente `libpam.so` pero no sólo) que hacen de intermediarias entre los métodos de autenticación y los programas que los usan, permitiendo la posibilidad de desarrollar programes de forma independendiente del esquema de autenticación a utilizar. La idea es que un programa, gracias a que haya sido desarrollado mediante las librerías PAM, pueda utilizar un / os determinado / s módulo / s binarios (o un / os otro / s, según le interese) que se encargue / n del "trabajo sucio" de autenticación. El / los módulo / s concreto / s que utilizará el programa en un determinado momento lo escogerá el administrador del sistema, el cual podrá cambiar de módulo (de /etc/shadow a LDAP por ejemplo), si así lo deseara, sin que el programa correspondiente notara la diferencia. Resumiendo PAM facilita la vida a los desarrolladores para que en vez de escribir una compleja capa de autenticación para sus programas simplemente tienen que escribir un "hook" en PAM, y también facilita la vida a los administradores porque pueden configurar la autenticación de los programas que la necesitan de una forma centralizada y común sin necesidad de recordar cada modelo separado para cada programa.

##Archivos relacionados con PAM

1. **Los módulos**, ubicados en `/lib/security` (Fedora) o `/lib/x64_64-linux-gnu/security` (en Ubuntu). Muchos se instalan "de serie"junto con las librerías PAM pero también pueden ser "de terceros". En cualquier caso, cada módulo implementa un método de autenticación diferente y básicamente puede devolver dos valores: "éxito" (PAM_SUCCESS) o "fallo" (PAM_PERM_DENIED u otros equivalentes) .

2. **Los ficheros de configuración de los módulos** anteriores (si es que tienen), ubicados en `/etc/security`

3. **Los ficheros de configuración proporcionados por cada aplicación**, encargados de establecer qué métodos de autenticación utilizará esta. Son archivos de texto que tienen como nombre el nombre de la aplicación asociada y están ubicados dentro del directorio `/etc/pam.d`.

##Módulos

Respecte el punto 1., decir que algunos de los módulos oficiales más importantes son los siguientes (consultar http://www.linux-pam.org/Linux-PAM-html/sag-module-reference.html o bien la página del manual "pam_xxx "para saber más): 

!!!NOTE "Nota"
    En Ubuntu estos módulos -y muchos otros- se encuentran dentro del paquete `libpam-modules` "(instalado por defecto en el sistema). En Fedora se encuentran en el paquete `pam` (también instalado por defecto)


|Módulo|Función|
|------|-------|
|**pam_unix.so**|Realiza la autenticación mediante el método tradicional (`/etc/passwd` y `/etc/shadow`). Si se quiere realizar la autenticación contra usuarios / contraseñas guardados en bases de dadesBerkeleyDB se puede usar entonces el módulo pam_userdb.so
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
|**pam_mkhomedir.so**|Crea la carpeta personal de un usuario cuando se loguea por primera vez en el sistema. Útil para cuando el usuario no es local sino que se encuentra en alguna BD remota o serv.|
**LDAPpam_systemd.so**|Només es un módulo de sesión (ver más abajo). Apoya el servicio systemd-login|

También existen otros módulos no oficiales pero muy interesantes que se pueden instalar como paquetes estándar (para encontrar estos y muchos otros, puede ejecutar `apt search libpam` -Ubuntu- o bien `dnf search pam` -en Fedora -): 

|**pam_captcha.so**| Muestra un texto gráfico mediante figlet a modo de captcha. Su página oficial es https://github.com/jordansissel/pam_captcha Atenció: No está empaquetado en las distribuciones más importantes|
|**pam_oath.so**|Implementa sistema de autenticación con contraseñas de un solo uso (OTP). La página oficial es http://www.nongnu.org/oath-toolkit
|**pam_google_authenticator.so**|Utilitza los servidores de Google para realizar el logueo en dos pasos (con contraseñas de un solo uso, las OTP). Su página oficial es https://github.com/google/google-authenticator-libpam
|**pam_usb.so** DEPRECATED|Solo permite el inicio de sesión si hay un lápiz Usb enchufado en el ordenador. Su página oficial és https://github.com/aluzzardi/pam_usb


pam_ldap.so Realitza l'autenticació contra usuaris/contrasenyes guardats a un servidor
Ldap. La seva pàgina oficial és http://www.padl.com/OSS/pam_ldap.html
pam_mariadb.so Realitza l'autenticació contra usuaris/contrasenyes guardats a un servidor
MariaDB.La seva pagina oficial és https://mariadb.com/kb/en/pam-
authentication-plugin .
pam_mysql.so Realitza l'autentiació contra usuaris/contrasenyes guardats a un servidor
MySQL. La seva pàgina oficial és https://github.com/NigelCunningham/pam-
MySQL . D'altra banda, dir que existeix un mòdul PAM de MySQL oficial,
però és comercial (https://dev.mysql.com/doc/refman/5.7/en/pam-pluggable-
authentication.html)
pam_pgsql.so Realitza l'autentiació contra usuaris/contrasenyes guardats a un servidor
PostgreSQL. La seva pàgina és https://github.com/pam-pgsql/pam-pgsql
pam_sqlite3.so Realitza l'autentiació contra usuaris/contrasenyes guardats a un servidor
SQLite3. La seva pàgina oficial és https://github.com/HormyAJP/pam_sqlite3
pam_abl.so Bloqueja noms d'usuari/IPs remotes que intenten loguejar al sistema
(similar en intenció a Fail2ban). La seva pàgina oficial és
https://github.com/deksai/pam_abl
NOTA: En el cas de voler desenvolupar una aplicació pròpia (en C) que faci ús d'algun dels mòduls anteriors i se n'aprofiti
de la seva funcionalitat, un petit tutorial el podreu trobar aquí: https://fedetask.com/writing-a-linux-pam-aware-application .
En el cas de voler desenvolupar un mòdul PAM pròpiament dit, un petit tutorial el podreu trobar aquí: https://fedetask.com/
write-linux-pam-module En qualsevol cas, la guia oficial del desenvolupador PAM es troba a
http://www.linux-
pam.org/Linux-PAM-html/Linux-PAM_ADG.html i http://www.linux-pam.org/Linux-PAM-html/Linux-PAM_MWG.html ,
respectivament.

##Fitxers de configuració de les aplicacions
Al punt 3. ja hem dit que dins de /etc/pam.d trobem els fitxers de configuració que controlen el
comportament de les aplicacions homònimes que utilitzen els mòduls PAM (login, gdm, ssh, sudo,...).
Aquests fitxers consten de línies formades per tres camps (explicats a continuació), on cal tenir en compte
que l'ordre de les línies és molt important (es llegeixen de dalt a baix):
1 r camp: Defineix el tipus d'acció que realitza el mòdul PAM. Bàsicament hi ha quatre tipus, tres
dels quals sempre se solen executar amb el següent ordre: "auth", després "account" i després
"session"; l'acció "password" s'executa sota demanda: