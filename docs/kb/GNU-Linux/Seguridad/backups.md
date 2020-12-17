##Linux Backups

https://www.techrepublic.com/blog/linux-and-open-source/a-simple-rsync-script-to-back-up-your-home-directory/

Crear un script backup.sh y hacerlo ejecutable y en el cron... 

Esto mantiene perfectamente sincronizados dos directorios incluyendo los borrados de ficheros, si deseamos conservar los ficheros borrados podemos quitar el "delete":

    #!/bin/sh
    rsync -av —delete /home/ /media/javier/Disco2TB/thinkpad_rsync/

* la opcion a equivale a "ARCHIVO" Y es un acceso directo a todas estas opciones: 
-Dgloprt

The D itself is syntactic sugar for two other options: —devices and —specials. The devices option preserves device files, which is probably irrelevant if you are only backing up your home directory, while the specials option preserves "special" files such as symlinks.

The g stands for "group", and preserves group ownership.

The l option copies symlinks as symlinks, rather than as files.

The o stands for "owner", and preserves user account ownership.

The p preserves file permissions.

The r stands for "recursive", and tells rsync to read all directories within the current directory, all directories within those subdirectories, and so on.

The t preserves modification times.

------------------
