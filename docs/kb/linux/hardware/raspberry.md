#Raspberry Pi

## Asignar una IP estática al Raspberry Pi

Modificamos el fichero de configuración del cliente dhcp

    sudo nano /etc/dhcpcd.conf

dejamos el fichero así:
    
    interface eth0 # o wlan0 para wifi
    static ip_address=192.168.1.253/24
    static routers=192.168.1.1
    static domain_name_servers=8.8.8.8 8.8.4.4


##Imagen de la tarjeta SD del Raspberry

*Este proceso solo funciona si las tarjetas son del mismo tamaño*

Hacemos df -h para ver todas las unidades:

    df -h
     
    S.ficheros     Tamaño Usados  Disp Uso% Montado en
    udev             3,9G   4,0K  3,9G   1% /dev
    tmpfs            789M   1,8M  787M   1% /run
    /dev/sdb2         50G    11G   36G  24% /
    none             4,0K      0  4,0K   0% /sys/fs/cgroup
    none             5,0M      0  5,0M   0% /run/lock
    none             3,9G    76K  3,9G   1% /run/shm
    none             100M    56K  100M   1% /run/user
    /dev/sdb1        511M   3,4M  508M   1% /boot/efi
    /dev/sda         233G   202G   32G  87% /media/backups
    /dev/sdc1        1,8T   939G  803G  54% /home
    /dev/sdf6        6,3G   4,1G  2,0G  68% /media/javier/root
    /dev/sdf3         27M   438K   25M   2% /media/javier/SETTINGS
    /dev/sdf5         60M    20M   40M  33% /media/javier/BOOT
    
    
Vemos que en este caso las distintas particiones de la tarjeta del raspberry son sdf6, sdf3 y sdf5 todas ellas en la unidad sdf

Para hacer backup de la tarjeta ejecutamos el comando:

    sudo dd bs=4M if=/dev/sdf of=raspbian_11_2_2016.img
     
    1895+0 registros leídos
    1895+0 registros escritos
    7948206080 bytes (7,9 GB) copiados, 408,713 s, 19,4 MB/s


para recuperar el backup en otra tarjeta:

    sudo dd bs=4M if=raspbian_11_2_2016.img of=/dev/sdf

Estos ficheros de imagen en ocasiones pueden ser grandes, por tanto se puede usar el pipe para redirigir la entrada y salida a un fichero zip de esta forma:

Para comprimir de la tarjeta a un fichero    

    sudo dd bs=4M if=/dev/sdf | gzip &gt; rasbian.img.gz    
   
Para extraer de un fichero a una tarjeta:

    sudo gunzip --stdout rasbian.img.gz | dd bs=4m of=/dev/sdf
    
Me ha pasado después de clonar la tarjeta que no me reconoce el disco duro externo de 2.0 TB que uso como NAS. En ese caso ejecutar el comando:

    sudo rpi-update; sudo reboot
    
Fuentes:

https://www.raspberrypi.org/documentation/linux/filesystem/backup.md
https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=126117

##Blocklist para pi-hole

Probablemente La mejor y única lista que necesitas añadir a tu pi-hole

https://www.reddit.com/r/pihole/comments/bppug1/introducing_the/

https://dbl.oisd.nl