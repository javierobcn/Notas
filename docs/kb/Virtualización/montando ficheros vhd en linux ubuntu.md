## Montar discos virtuales en formato VHD

Es posible montar discos virtuales en formato VHD en una carpeta en tu instalación de Ubuntu. Veamos como...

* Se instalan las utilidades virtualbox-fuse

    ```sudo apt-get install virtualbox-fuse```

* Para montar una unidad vhd

    ```sudo vdfuse -f /path/to/file.vhd /path/to/mountpoint```


Una vez montada la unidad, /path/to/mountpoint contendrá unos ficheros como 'EntireDisk', 'Partition1′, etc. Si solo hay una partición , probablemente será lo quiera verse, así que para montar esa partición en otra carpeta hay que ejecutar:
mount /path/to/mountpoint/Partition1 /path/to/someother/mountpoint

Y ahora si en /path/to/someother/mountpoint tendremos el sistema de archivos

###Fuentes

http://www.ubuntugeek.com/how-to-mount-virtualbox-drive-image-vdi-in-ubuntu-12-1012-04.html