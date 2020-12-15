#Gestión de Usuarios en Linux

##Ficheros principales
* `/etc/passwd` → bd del sistema
* `/etc/shadow` → contraseñas de usuarios
* `/etc/group` → bd  de grupos y pertenencias
* `/etc/adduser.conf`

Ejemplo de fichero `/etc/passwd`

``` bash
rtkit:x:120:128:RealtimeKit,,,:/proc:/bin/false
saned:x:121:129::/var/lib/saned:/bin/false
usbmux:x:122:46:usbmux daemon,,,:/var/lib/usbmux:/bin/false
javier:x:1000:1000:javier,,,:/home/javier:/bin/bash
postgres:x:123:131:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash
mysql:x:124:132:MySQL Server,,,:/nonexistent:/bin/false
```

Estructura del fichero `/etc/passwd`

- User: el root siempre tiene UID = 0 y GID = 0
- pwd
- UID
- GID
- data: separado por ,
- homedir:
- shell


Los UID pueden ir de 0 a 65535, normalmente del 0 al 999 son de sistema y los usuarios que se añaden posteriormente tienen un UID > 1000

!!!NOTE "Nota"
    www-data siempre tiene el mismo userid, suele ser el 33, podemos comprobarlo en cualquier sistema con el comando:
    ```
    cat /etc/passwd | grep www-data -i
    ```
    El cual nos devolverá algo muy parecido a :

    ```
    www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
    ```

Si queremos quitarle la contraseña a un usuario le quitamos la x en password

!!!NOTE "Nota"
    Uno de los “tricks” para crear un **usuario root sin contraseña** y dejar una puerta abierta es duplicar la linea de root como toor y le quitamos la x en password.

## Shells

`cat /etc/shells` --> ver los shells disponibles

Si le ponemos a un usuario el shell `/bin/false` cuando este usuario entre hará un exit inmediatamente

/usr/bin/nologin → lee de un fichero txt

## Gestión de usuarios

**`adduser`** --> inicia el proceso de agregar usuario mediante un asistente. Hay un fichero de opciones con parámetros predefinidos en `/etc/adduser.conf`

**`useradd`** --> comando de bajo nivel para agregar usuarios con opciones:

- m homedir
- d ruta dir home
- g GID
- u UID
- s shell
- P no usar (fallo de seguridad)

**`deluser nombreusuario --remove-home`** → elimina el usuario nombreusuario y su home, por defecto no elimina la home.

**`userdel`** → inicia el proceso de borrar un usuario con opciones definidas en `/etc/userdel.conf`

**`usermod`** → modificar usuario. 

*  Ej. `usermod -s /bin/false usuario` → quita el shell al usuario especificado y le impide hacer login. 
*  `usermod -m` → mover la home a otra carpeta
*  `usermod -a -G sudo javier` --> Agrega el usuario **Javier** al grupo **sudo**, lo cual le permitirá impersonarse en el usuario root mediante el comando sudo

    
## Gestión de grupos

**`groupadd nombregrupo`** → añade un nuevo grupo al sistema
**`groupdel`** --> borrar grupo
**`groupmod`** --> Modificar grupo

`gpasswd` → los grupos pueden tener contraseñas

`newgrp` → para iniciar sesión en un grupo y pedirá el password si está establecido

`vipw` → programa especifico para modificar los ficheros passwd y group de /etc

## Contraseñas
`passwd` → cambia el password para el usuario actual y nuevos

`chage` → cambia la expiración del password

`chage` -l usuario → muestra información acerca de la clave y de la cuenta.

`pwgen` → genera contraseñas muy feas

`pwgen -1`  → genera solo una contraseña

`pwgen -nyc 12 `  

- → n - incluye passwords con números
- → y - incluye símbolos
- → c - incluye mayúsculas o capitales en la clave
- → 12 → hace claves de 12 caracteres

## Sudo
`su` → permite al root metamorfosearse en otro usuario

`su -` → es lo correcto puesto que de esta forma arrastra las variables de entorno

`su <user>` → va a pedir el password de ese usuario

`sudo` → permite escalar privilegios y por eso no gusta a ciertos admins. Lee el fichero `/etc/sudoers` para determinar que usuarios pueden hacer sudo.

`sudo su - ` → permite a un usuario transformarse en root y arrastra sus variables 

`sudo -k` → olvida el password memorizado

Se puede bajar el fuente de sudo y compilarlo con frases divertidas, cuando falle te dice cosas.

/var/mail/usuario → correo interno de los usuarios

w → comando para info de los usuarios conectados
who → info de los usuarios en modo reducido
whoami → en un terminal sin prompt o $ nos dice que usuario estamos utilizando
id → parecido a whoami pero nos dice los GID o UID del usuario
echo $UID → nos muestra el UID del usuario
$ -> indica que es un usuario del sistema
# -> indica que es el usuario root

## Prompt
$PS1 define el prompt del usuario, por ej, en ubuntu
``` bash
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
```
/Q /W /t /u /h

El prompt puede contener programación

man bash para ver PS1 y \$PS2 → al pulsar \ en un comando muy largo sale el prompt 2

Buscar en google cool prompt bash para ver mas ejemplos incluso generadores de prompts on line

Para definir el prompt de manera permanente para un usuario hacerlo en /root/.bashrc

Para definir el prompt de manera permanente para todos los usuarios hacerlo en: /etc/profile
