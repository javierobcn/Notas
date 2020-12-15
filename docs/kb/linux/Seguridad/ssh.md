#SSH

##Servidores

(pendiente)

##Clientes

###SSH Keys y seguridad linux

####Conectarse sin contraseñas
Si nunca te has creado una llave ssh, elimina, si existe, en local la carpeta ~/.ssh

En local ejecutamos los siguientes comandos para crearla de nuevo:

``` bash
mkdir ~/.ssh
chmod 700 ~/.ssh
```

Generar el par de claves RSA (pública y privada):

`ssh-keygen -t rsa`

Se transfiere la clave al host utilizando el comando local

`ssh-copy-id user@tuserver.example.com`

El comando `ssh-copy-id` pedirá por última la vez la clave y después copiará nuestra clave al host de destino.

