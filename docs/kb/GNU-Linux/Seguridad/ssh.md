#SSH

##SSH Keys y seguridad linux

###Conectarse sin contraseñas
Si nunca te has creado una llave ssh, elimina, si existe, en local la carpeta ~/.ssh

En local ejecutamos los siguientes comandos para crearla de nuevo:

``` bash
mkdir ~/.ssh
chmod 700 ~/.ssh
```

Generar el par de claves RSA (pública y privada):

    ssh-keygen -t rsa -b 4096 -C "hola@example.com"

!!!note "Nota"
    * -t indica el tipo de clave a generar, podría ser “dsa”, “ecdsa”, “ed25519”, o “rsa”.
    * -b bits   Especifica el número de bits en la clave para crear. Para claves RSA, el tamaño mínimo es de 1024 bits y el predeterminado es de 2048 bits.
    * -C "Comentario": Establece una etiqueta identificativa para esta clave

Se transfiere la clave al host utilizando el comando local

`ssh-copy-id user@tuserver.example.com`

El comando `ssh-copy-id` pedirá por última la vez la clave y después copiará nuestra clave al host de destino.

`ssh-add` para que nuestro cliente ssh tenga en cuenta las nuevas claves generadas.

Ya se puede conectar sin contraseña utilizando

    ssh clientes.sugestionweb.com -l root


# Agregar las claves al ssh-agent

Iniciar el agente SSH en segundo plano.

    $ eval "$(ssh-agent -s)"
    > Agent pid 59566

Agrega tu llave privada SSH al ssh-agent. Si creaste tu llave con un nombre distinto, o si estás agregando una llave existente que tiene un nombre distinto, reemplaza id_rsa en el comando con el nombre de tu archivo de llave privada.

    $ ssh-add ~/.ssh/id_rsa
   
### Eliminar de local la clave ssh de un servidor

    ssh-keygen -f "/root/.ssh/known_hosts" -R 192.168.1.38


##Deshabilitar autenticación por passwords

Primero copia de seguridad del fichero sshd_config actual y solo lectura con:
    
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
    sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
    
Para poder hacer util lo anteriormente mencionado dejaremos solo la autenticación por clave eliminando la autenticación por password para esto editaremos de nuevo /etc/ssh/sshd_config

    PasswordAuthentication no

De está forma se elimina el impacto de ataques por fuerza bruta.

##No permitir logeo como root

Puesto que root es el usuario con mas privilegios y el que se suele intentar explotar pues no permitiremos el logeo como root añadiendo en /etc/ssh/sshd_config

    PermitRootLogin no

Para reiniciar el servicio ssh después de hacer cambios en la config.

    service ssh restart
    
##Banear a las ips que hacen mas de 5 logeos erroneos

    apt-get install fail2ban
    
una vez instalado crearemos una directiva para ssh
    
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    nano /etc/fail2ban/jail.local

Comprobamos la siguiente directiva

    [ssh]enabled = true
    port = ssh
    filter = sshd
    logpath = /var/log/auth.log
    maxretry = 5

reiniciamos fail2ban

    service fail2ban restart

    