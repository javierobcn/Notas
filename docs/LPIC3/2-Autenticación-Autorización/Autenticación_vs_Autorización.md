
#Autenticación vs Autorización
##Autenticación
**Se denomina "autenticación" al proceso de verificar una identidad**. Este proceso implica la identificación de un elemento (que suele ser un usuario pero también puede ser un programa o, en el caso de interacciones por red, incluso una máquina) por parte del sistema verificador (que puede ser un programa local como gdm, login, sudo o su o un servidor remoto como SSH, POP / SMTP, etc)

Hay muchas maneras de autenticar: mediante contraseñas simples, contraseñas de una sola vez (OTP), certificados ,, exploraciones biométricos, etc ... todos estos modos se denominan "credenciales" en general.

El tipo exacto de credencial requerida estará definido por el mecanismo de autenticación que el sistema verificador tenga configurado. Los mecanismos más habituales (y que se pueden combinar entre sí) son:

* **Basado en contraseñas simples**: Permite autenticar usuarios si éstos proporcionan un nombre y contraseña reconocidos como válidos por el sistema verificador. Se basa en algo que el usuario sabe
* **Basado en contraseñas OTP**: A one-time password (OTP) is an automatically generated numérico or alphanumeric string of characters that authenticates the user for a single transaction or login session. an OTP is more secure than a static password because it can not be reused. Very often OTPs are involved in
some kind of 2FA ( "Two Factor Authentication") or MFA ( "Multiple Factor Authentication") process where, after user providing a simple password, he / she must generate the OTP in his / her pre-tied hardware device (which can be an specialized one or simply a mobile phone using some specific app
-although if using the SMSs one then the OTP is not generated on device but received from third-party server-) to then provide it too so that finalize the authentication. De este modo, las autenticaciones 2FA se basan en algo que el usuario sabe (la contraseña simple inicial) más algo que el usuario tiene
físicamente (el dispositivo hardware / app móvil donde se recibe la OTP). 

    Para más información puede consultar el articulo: https://www.eff.org/deeplinks/2017/09/guide-common-types-two-factor-authentication-web y también https://sec.eff.org/topics/two-factor-authentication

    !!!NOTE "NOTA"
        Una "segunda generación de autenticación 2FA es la que hace uso de claves UF2 (" Universal 2 Factor ") para evitar el uso de apps móviles a la hora de gestionar las contraseñas OTP (debido a sus posibles vulnerabilidades). Las claves UF2 son dispositivos hardware de tipo USB (o también inalámbricos de tipo NFC) que hacen uso de criptografía asimétrica y se pueden configurar para autenticarse automáticamente contra, sobre todo, aplicaciones web (Correo, redes sociales, etc). More specifically, when a user tries to access año (Previously configured accordingly) account, after first entering static password he / she should glance at the device and enter the displayed 2FA code back into the site or app. Other versions of keys can automatically transfer the 2FA code to the recognized site domain name when plugged into a computer USB puerto (if this domain name has been Introduced Previously into key) without manual intervention. Estas claves pueden estar desarrolladas por diferentes fabricantes (Uno de los más conocidos es Yubico, que fabrica sus "yubikeys") pero todos siguen el mismo estándar UF2, estandarizado por la FIDO Alliance (un conglomerado de empresas entre las que se encuentran Google, Facebook, Microsoft, etc).

    !!!NOTE "NOTA"
        Otro ejemplo de autenticación 2FA (esta vez sin que intervengan OTPs, pero) es la proporcionada los cajeros automáticos para que se basa en algo que el usuario tiene físicamente (la tarjeta bancaria) y algo que el usuario sabe (el pin).

* **Basado en certificados (de cliente)**: Permite autenticar la máquina del usuario. Funciona así: esta máquina envía un certificado (que es un archivo criptográficamente vinculado a dicha máquina) a través de la
red a un servidor que deberá confirmar la validez del certificado y, por tanto, la identidad de la máquina en cuestión. Se basa en algo que la máquina del usuario guarda

!!!NOTE "NOTA"
    NOTA: El protocolo TLS, muy utilizado en Internet para asegurar las comunicaciones de los navegadores con servidores web (entre otros), utiliza un mecanismo muy similar también basado en certificados pero en este caso de servidor.

* **Basado en "smart cards"**: Variante "hardware" del mecanismo anterior. La "smart card" (o, más habitual actualmente, una "app" de móvil) almacena el certificado; cuando el usuario inserta un determinado "token" en el sistema, este leerá el certificado y concederá el acceso. Se basa en algo que el usuario tiene físicamente 
* **Biométrico**: Existen diferentes métodos, como la huella dactilar, la forma de la mano, el patrón del iris, la voz, etc. En https://cromwell-intl.com/cybersecurity/authentication.html#authtool_biometric se puede
consultar una lista de fabricantes de componentes biométricos. Se basa en algo que el usuario es.
* **Mediante Kerberos**: Sistema de credenciales de corta duración y multi-servidor. Funciona así: el usuario primero presenta al servidor Kerberos unas credenciales propias (normalmente, son un nombre de usuario y contraseña, pero pueden ser de cualquiera de los otros tipos mencionados: certificados, biométricos ... o una combinación de estos), para identificarse y así poder recibir de este servidor la credencial de corta duración, llamada TGT. Este TGT utilizará a partir de entonces para acceder automáticamente a otros servicios, (Como servidores de correo electrónico, de carpetas compartidas, etc). La "gracia" de la autenticación haciendo servir Kerberos es que permite realizar sólo un proceso de autenticación (al principio, para pedir el TGT)
porque a partir de entonces se reaprovecha este proceso para acceder a múltiples servidores diferentes de forma totalmente automatizada (mientras dure el período de validez del TGT, claro.). Este hecho es lo que
llama "Single Sign-On" o SSO y se utiliza principalmente en entornos corporativos.

!!!NOTE "Nota"
    NOTA: Hay que tener en cuenta que el SSO pone "todos los huevos en una cesta": si sólo una contraseña es robada o adivinada, entonces todos los recursos e identidades están comprometidas. Hay que tener un equilibrio, pues, entre conveniencia y seguridad.

Tal como hemos dicho, el sistema verificador debe tener configurado un determinado mecanismo de autenticación. la tarea de este mecanismo, sea cual sea éste, sin embargo, siempre es la misma: comparar cada credencial presentada con las que tenga almacenadas previamente en una (o varias) "bases de datos": si ambas credenciales coinciden, la comprobación será exitosa y la parte solicitante autenticará.

En el caso concreto de utilizar la autenticación basado en contraseñas, las "bases de datos" que consulta el sistema verificador (que es donde, en definitiva, están guardados los nombres y contraseñas válidos) se pueden encontrar:

* Localmente dentro del propio sistema verificador. Normalmente en forma de archivos de texto (como es el caso del archivo "/etc/shadow" Linux) o de registro binario (como es el caso de Windows)
* En un servidor remoto que sea accedido cuando sea necesario por el sistema verificador. Este servidor remoto puede ser de diferentes tipos según los requisitos que necesite nuestro sistema de autenticación particular pero
básicamente deben proporcionar un sistema de almacenar nombres y contraseñas. Los más comunes son:
    - Un servidor LDAP
    - Un sistema gestor de base de datos relacional (SGBD)
    - Un servidor Kerberos (que proporcionará TGTs)
    - Un servidor RADIUS

    !!!NOTE "Nota"
        Tanto los servidores LDAP con los SGBDs pueden contener, además de la información estrictamente relacionada con la autenticación (nombres y contraseñas, básicamente), diferente información extra relacionada con los usuarios autenticados (como datos personales: teléfono, email, etc o datos de sistema: ruta de la carpeta personal, shell preferido, etc, etc). De hecho, incluso se podría combinar el uso de Kerberos (o RADIUS) con otro servidor LDAP o SGBD, delegando así el proceso de autenticación sólo en Kerberos (o RADIUS) y utilizando la base de datos LDAP / relacional sólo de fuente de información complementaria. RADIUS, por su parte, también incorpora ciertas funcionalidades relacionadas con procesos de autorizaciones, principalmente relacionadas con el acceso a redes

##Autorización

Se llama "autorización", por otra parte, al proceso que determina qué puede hacer y / o donde puede acceder el elemento autenticado. Una vez un determinado elemento ha sido identificado (por ejemplo, un usuario), el sistema determinará, con los datos que obtenga de este usuario (provenientes de diferentes fuentes), a qué recursos (es decir, a qué programas, carpetas y ficheros, hardware, etc) estará autorizado a entrar / conectar / leer / modificar / escribir / eliminar / ejecutar, etc y en cuáles no. Así pues, hay que distinguir entre autenticación y la autorización para que son dos
procesos separados.

Las fuentes de información que puede utilizar el sistema para construir el esquema de autorizaciones de un determinado usuario autenticado son muchas y muy variadas. Desde el sistema de permisos de archivos y carpetas clásico pasando por las ACLs y las "capabilities" hasta llegar a esquemas más complejos como los MACs SELinux (o AppArmor) o como los subsistemas proporcionados por sudo o el framework Polk, entre muchos otros. Todo ello combinado con el posible uso de servidores remotos LDAP (o relacionales o RADIUS) para completar toda esta información.
