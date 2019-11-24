## Login LDAP desde cliente con SSSD
### Introducción
En Linux se puede utilizar el demonio SSSD para autenticar al usuario contra servidores LDAP remotos (Combinados con servidores Kerberos o no) además de identificarlos. Mediante SSSD todo el proceso de autenticación / identificación del usuario se produce en el cliente de una forma homogénea y coherente, independientemente de la distribución Linux allí instalada.

!!!note "Nota"
    Además de autenticarse contra servidores LDAP "pelados" o combinados con Kerberos, el demonio SSSD también permite autenticar usuarios contra sistemas integrales empresariales como FreeIPA o Active Directory (los cuales internamente se basan en LDAP / Kerberos). En cambio, no puede trabajar (todavía) con SGBDs o servidores RADIUS como fuente de autenticación / identificación

Una gran ventaja de utilizar SSSD en vez de los módulos PAM / NSS "standalone"
individualmente es que este demonio guarda una caché (en la carpeta `/var/lib/sss/db`) que permite el acceso "Offline" a / los sistema/s cliente/s (sin tener ninguna cuenta local diferente) en el caso de que el servidor LDAP / Kerberos remoto no esté disponible en ese momento o, en caso de que sí, disminuir su carga.

!!!note "Nota"
    NOTA: El demonio SSSD también ofrece una interfaz D-Bus para poder interactuar con el sistema mediante este método y así obtener, por ejemplo, información extra sobre el usuario (tal como veremos).

El demonio SSSD proporciona sus propios módulos PAM y NSS para conectar con servidores LDAP / Kerberos y LDAP, respectivamente, los cuales son diferentes de los módulos "standalone" pam_ldap / pam_krb5 y nss_ldap ya conocidos. Esto es porque SSSD ofrece funcionalidades extra como un framework conjunto y librerías homogéneas, un mecanismo de caché de credenciales -similar al que ofrecía el demonio ncsd, ya obsoleto-, una interfaz D-Bus, etc. Para que los programas de inicio de sesión (login, gdm, su, sudo, ssh, etc) utilicen los módulos PAM / NSS propios de SSSD deberemos realizar un conjunto de configuraciones al sistema que explicaremos a continuación.

!!!note "Nota"
    NOTA: En Ubuntu hay que instalar el paquete "sssd" (es decir, el demonio SSSD no viene preinstal.lat "de fábrica"). Afortunadamente, al instalar este paquete ya se instalarán automáticamente como dependencia el resto de paquetes que podamos necesitar, como los conectores con los diferentes providers: "sssd-ldap", "sssd-krb5", "sssd-ipa", etc. En Fedora todos estos paquetes ya vienen instalados "de fábrica".

###Configuración de SSSD:
SSSD lee los archivos de configuración en este orden: primero lee el archivo primario `/etc/sssd/sssd.conf` y luego, otros archivos `* .conf` en `/etc/sssd/conf.d` (en orden alfabético). Si aparece el mismo parámetro en múltiples archivos de configuración, SSSD usa el último parámetro de lectura. Esto le permite usar el valor predeterminado `/etc/sssd/sssd.conf` en todos los clientes y aagregar configuraciones adicionales en otros archivos de configuración para extender la funcionalidad individualmente por cliente. 

!!!warning "Atención" 
    Todos estos archivos deben ser propiedad de `root:root` y
    tener permisos `600` de lo contrario el servicio sssd no se iniciará.

Los proveedores de autenticación e identidad se configuran como "dominios" en el archivo de configuración SSSD.

Puede configurar varios dominios para SSSD pero al menos un dominio debe estar configurado, de lo contrario, SSSD no arrancará. Un solo dominio se puede usar como:

*  Un proveedor de autenticación (para solicitudes de autenticación)
*  Un proveedor de identidad (para información del usuario)
*  Un proveedor de control de acceso (para solicitudes de autorización). No los estudiaremos aquí.
*  Una combinación de estos proveedores (si todas las operaciones correspondientes se realizan dentro de un solo servidor)

!!!note "Nota"
    También hay lo que se llama un proveedor "proxy". Este proveedor funciona como un intermediario de retransmisión entre SSSD y recursos que SSSD de otra forma no podrían usar. Cuando se usa un proveedor proxy, SSSD se conecta al servicio proxy, y el proxy carga las bibliotecas especificadas. Con un proveedor de proxy, puede configurar SSSD para utilizar métodos de autenticación alternativos, como un escáner de huellas digitales, entre otras cosas. 

#### Sección [sssd]
En el archivo "sssd.conf" debe haber al menos una sección general [sssd] y una sección para cada dominio. Debajo de la sección [sssd] debemos tener en cuenta esta línea (más información en man sssd.conf):

    domains =

Especifica una lista separada por comas de dominios definidos en el orden que desee para ser consultado Por lo tanto, si un dominio no aparece en esta lista, no se consultará aunque esté definido en el archivo "sssd.conf"

#### Sección [domain/xxx]
Las secciones correspondientes a dominios definidos deben titularse así `[domain/xxx]` donde "xxx" puede ser cualquier cosa. Debajo de una sección de dominio debemos tener en cuenta estas líneas (más en man sssd.conf):

-  **Line "auth_provider =**": establece el proveedor de autenticación utilizado para el dominio. Los valores posibles son:
        -  "ldap", "krb5", "ipa", "ad" o "proxy", entre otros. Dependiendo del proveedor elegido, habrá sea ​​necesario escribir líneas más específicas (ver man sssd-ldap, man sssd-krb5, man sssd-ipa u man sssd-ad para más detalles).
-  -Line **"id_provider ="**: establece el proveedor de identidad utilizado para el dominio. Los valores posibles son: "ldap", "archivos", "ipa", "anuncio" o "proxy". Dependiendo del proveedor elegido, habrá que escribir líneas más específicas (vea man sssd-ldap, man sssd-files, man sssd-ipa o man sssd-ad para más detalles).
-  -Line **"access_provider ="**: establece el proveedor de acceso utilizado para el dominio, que se utiliza para evaluar qué usuarios tienen acceso al sistema. Incluso si un usuario se autentica con éxito, si no Si cumple con los criterios proporcionados por el proveedor de acceso, su acceso será denegado. Los valores posibles son:
"ldap", "krb5", "simple", "ipa", "ad", "proxy", "denegar" (siempre niega el acceso) o "permitir" (por defecto,siempre permite el acceso). Dependiendo del proveedor elegido, habrá que escribir más.
-  **líneas específicas** (vea man sssd-ldap, man sssd-krb5, man sssd-simple, man sssd-ipa o man sssd-ad para detalles).

!!!note "Nota"
    NOTA: El proveedor de acceso "simple" permite o niega el acceso basado en una lista de nombres de usuario o grupos. Permite restringir el acceso a máquinas específicas. Por ejemplo, en las computadoras portátiles de la compañía, puede usar el proveedor de acceso simple  para restringir el acceso solo a un usuario específico o un grupo específico. Otros usuarios o grupos no podrán iniciar sesión incluso si se autentican correctamente en el proveedor de autenticación configurado.

    ```
    [domain/nombre_dominio]
    ...
    access_provider = simple
    simple_allow_users = usuario1, usuario2
    #simple_allow_groups = group1
    ```

Si el proveedor de acceso que está utilizando es el "ldap", también puede especificar un filtro de control de acceso LDAP que el usuario debe coincidir para poder acceder al sistema.

    [domain/domain_name]
    ...
    access_provider = ldap
    ldap_access_filter = (memberOf=cn=allowedusers,ou=Groups,dc=example,dc=com)
    #ldap_access_order = filter, host, authorized_service

!!!note "Nota"
    NOTA: La directiva ldap_access_order puede tener estos valores (se pueden indicar por orden de aplicación):
        
        *"filter" : Se usa el filtro indicado en ldap_access_filter como criterio. Valor per defecto
        *"host" : Se usa el atributo "host" en el directorio como criterio
        *"authorized_service" : Se usa el valor de "authorizedService" en el directorio como criterio
        *"expire" : Se usa el valor de la directiva ldap_account_expire_policy como criterio

-  **-Line "chpass_provider =**": establece el proveedor que debe manejar las operaciones de cambio de contraseña para el dominio. Los valores posibles son: "ldap", "krb5", "ipa", "ad", "proxy" o "none" (esto explícitamente deshabilita la capacidad de cambiar las contraseñas). Si no se especifica esta línea, entonces se usa por defecto el valor especificado en la línea "id_provider". Ver man sssd-sudo para detalles 

    !!!note "Nota"  
        Nota SSSD no almacena en caché las credenciales de usuario de forma predeterminada. Entonces, al procesar solicitudes de autenticación,de manera predeterminada, SSSD siempre contacta al proveedor de identidad; si el proveedor no está disponible, la autenticación de usuario falla Para garantizar que las credenciales se almacenen localmente después de autenticar con éxito a los usuarios para que puedan mantener autenticación incluso cuando el proveedor de identidad no está disponible, debe habilitar el almacenamiento en caché de credenciales local agregando la línea cache_credentials = true debajo de la sección de dominio correspondiente. Por defecto, la credencial la memoria caché nunca caduca: si desea que sssd elimine las credenciales almacenadas en caché, account_cache_expiration = line hacer que caduquen después del número de días especificado.

    !!!note "Nota"  
        Cuando un usuario intenta una operación de sudo, ya sabemos que SSSD contacta al proveedor de identidad / sudo definido en el dominio para obtener la información requerida sobre la configuración actual de sudo. Si la línea cache_credentials se establece en true,también almacenará esa información de sudo en una memoria caché, para que los usuarios puedan realizar operaciones de sudo incluso cuando LDAP / IPA / AD El servidor está fuera de línea.
 
####Secciones opcionales [pam] y / o [nss]
Las secciones opcionales [pam] y / o [nss] también pueden aparecer en el archivo "sssd.conf". Podrían ser utilizadas para configurar algunos aspectos del comportamiento de los módulos PAM o NSS de SSSD, respectivamente. Por ejemplo, si se quiere configurar un límite de tiempo (en días) para cuánto tiempo SSSD permite la autenticación sin conexión si el proveedor de  identificación no está disponible, puede usar la línea 
`offline_credentials_expiration =` debajo de la sección `[pam]` para especificar ese límite de tiempo. Otras líneas interesantes para especificar debajo de la sección `[pam]` son `offline_failed_login_attempts =`, `offline_failed_login_delay =` o `reconnection_retries`, entre otros.

Igualmente, debajo de la sección `[nss]` algunas líneas interesantes que merecen atención son `filter_groups =` y `filter_users =` (que excluye a ciertos usuarios, por defecto, solo "root") de ser extraídos del backend NSS
Esto es particularmente útil para las cuentas del sistema .; esta opción también se puede establecer por dominio o incluir nombres totalmente calificados para filtrar solo usuarios del dominio en particular), `entry_cache_timeout =` (que especifica cuántos segundos, por defecto 5400- debe considerar sssd entradas válidas antes de preguntar al NSS backend otra vez),
        
    "entry_cache_nowait_percentage =",
    "override_homedir =",
    "override_shell =",
    "allowed_shells =", etc.


####Ejemplo 1 (un servidor LDAP como proveedor de autenticación e identidad)
Un fichero "sssd.conf" podría ser algo así:

    [sssd]
    domains=pepito
    [domain/pepito]
    auth_provider=ldap
    id_provider=ldap
    ldap_uri=ldaps://ldapserver.example.com
    ldap_search_base=dc=example,dc=com

!!!note "Nota"
    SSSD always uses an encrypted channel for authentication, which ensures that passwords are never sent over the network unencrypted but forces the LDAP server to run over TLS. If this LDAP server used a self-signed certificate, you must add the line `ldap_tls_reqcert=allow` in the `sssd.conf` file so that client doesn't reject it. If this LDAP used a ca-signed certificate instead, you should add the line `ldap_tls_cacert = /etc/pki/tls/certs/ca-bundle.crt` instead (pointing to the right CA's bundle file in each case). Anyway, if you wanted identity lookups (such as commands based on the id or getent utilities) were also encrypted (or if LDAP server only runs over TLS), you should add the "`ldap_id_use_start_tls =true` line.

!!!note "Nota"
    If LDAP server's configuration requires that queries to LDAP directory have to be authenticated, you should add the `ldap_default_bind_dn= cn=admin` and `ldap_default_authtok= 12345` lines to specify which user ("cn=admin" in this example) and password ("12345" in this example) should be used to do these queries, respectively.


####Example 2 (a KDC server as authentication provider and a LDAP server as identity provider)
A suitable sssd.conf file could be like this:
    [sssd]
    domains=pepito
    [domain/pepito]
    auth_provider=krb5
    krb5_server=kdc.example.com
    krb5_realm=EXAMPLE.COM
    id_provider=ldap
    ldap_uri= ...
    ldap_search_base= ...

!!!note "Nota"
    NOTA: If the Change Password service is not running on the KDC specified in "krb5_server" or "krb5_backup_server" lines, you can use the "krb5_passwd" line to specify the server where the service is running or a chpass_provider instead.


