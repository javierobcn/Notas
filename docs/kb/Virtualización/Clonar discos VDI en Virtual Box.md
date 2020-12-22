## Clonar discos VDI en Virtual Box

Recientemente he estado trasteando con Virtual Box y, a base de experimentar, he aprendido que clonar una máquina virtual no es tan fácil como copiar y renombrar el fichero VDI.

Una de las ventajas de la virtualización es la posibilidad de duplicar máquinas una vez que están configuradas a tu gusto. El primer intento que se me ocurrió fue el más rápido, copiar el fichero VDI con la imagen y renombrarlo. Pero al intentar adjuntar el nuevo disco copiado a una nueva máquina, para comprobar si arrancaba, apareció un error relacionado con que la máquina ya existía y además continuaba apareciendo el nombre anterior.

Tras realizar un poco de “Googling” he encontrado la forma de hacerlo, la apunto aquí para no olvidarme y por si ¿quién sabe?, resulta útil a alguien más.

Primero has de detener la máquina virtual que tiene asociado el disco que quieres clonar, liberar el disco de la máquina y eliminar la entrada del disco de la lista de medios, pero manteniéndolo para adjuntarlo de nuevo posteriormente.

En Linux, desde la consola ejecutamos el comando vboxmanage con el parámetro clonevd
   
    vboxmanage clonevdi origen.vdi destino.vdi

Desde Windows, acceder a una ventana MS-DOS y desde la carpeta donde se encuentre el fichero VDI origen ejecutar el siguiente comando:
   
    %VBOX_INSTALL_PATH%”vboxmanage.exe clonevdi origen.vdi destino.vdi

El proceso dura un ratito, dependiendo del tamaño de tu imagen, afortunadamente podremos ver un indicador del progreso de la operación.

Una vez finalizado el proceso, vuelve a agregar el disco origen a la lista de medios y vuelve a adjuntarlo a la máquina virtual original para dejar las cosas como estaban.

Al parecer, por lo que he logrado entender, cada imagen de disco ha de tener un identificador único, además, la tarjeta de red ha de tener una dirección MAC única también , todo esto hace inviable el sistema de copiar  el ficheroVDI para duplicar la máquina virtual.

Posibles problemas al arrancar una máquina clonada así:

    «Waiting for network configuration. Waiting up to 60 seconds for network configuration»

Hacer Login y ejecutar el comando

    ifconfig -a

Fijarse en el primer adaptador que será algo como eth0, eth1, ethx,

Editar el fichero  /etc/network/interfaces y cambiar ahí ethx para que coincida con el obtenido con el comando ifconfig -a
