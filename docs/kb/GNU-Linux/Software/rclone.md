## rclone

La navaja suiza del almacenamiento en nube

Es un programa de linea de comandos para realizar sincronizaciones de carpetas y ficheros ubicados en distintas máquinas o en distintos servicios de nube como dropbox, google drive, FTP, SFTP, etc. Es muy util para hacer copias de seguridad y mantener sincronizados directorios con servicios de almacenamiento.

## Instalación

    curl https://rclone.org/install.sh | sudo bash    
    
## Configuración

La configuracion se realiza mediante un asistente de configuración que aparece cuando escribimos
    
    rclone config

Por defecto toda la configuración se guarda en .config/rclone/rclone.conf

## Remotos disponibles

    Choose a number from below, or type in your own value
     1 / 1Fichier
       \ "fichier"
     2 / Alias for an existing remote
       \ "alias"
     3 / Amazon Drive
       \ "amazon cloud drive"
     4 / Amazon S3 Compliant Storage Provider (AWS, Alibaba, Ceph, Digital Ocean, Dreamhost, IBM COS, Minio, Tencent COS, etc)
       \ "s3"
     5 / Backblaze B2
       \ "b2"
     6 / Box
       \ "box"
     7 / Cache a remote
       \ "cache"
     8 / Citrix Sharefile
       \ "sharefile"
     9 / Dropbox
       \ "dropbox"
    10 / Encrypt/Decrypt a remote
       \ "crypt"
    11 / FTP Connection
       \ "ftp"
    12 / Google Cloud Storage (this is not Google Drive)
       \ "google cloud storage"
    13 / Google Drive
       \ "drive"
    14 / Google Photos
       \ "google photos"
    15 / Hubic
       \ "hubic"
    16 / In memory object storage system.
       \ "memory"
    17 / Jottacloud
       \ "jottacloud"
    18 / Koofr
       \ "koofr"
    19 / Local Disk
       \ "local"
    20 / Mail.ru Cloud
       \ "mailru"
    21 / Mega
       \ "mega"
    22 / Microsoft Azure Blob Storage
       \ "azureblob"
    23 / Microsoft OneDrive
       \ "onedrive"
    24 / OpenDrive
       \ "opendrive"
    25 / OpenStack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
       \ "swift"
    26 / Pcloud
       \ "pcloud"
    27 / Put.io
       \ "putio"
    28 / QingCloud Object Storage
       \ "qingstor"
    29 / SSH/SFTP Connection
       \ "sftp"
    30 / Sugarsync
       \ "sugarsync"
    31 / Tardigrade Decentralized Cloud Storage
       \ "tardigrade"
    32 / Transparently chunk/split large files
       \ "chunker"
    33 / Union merges the contents of several upstream fs
       \ "union"
    34 / Webdav
       \ "webdav"
    35 / Yandex Disk
       \ "yandex"
    36 / http Connection
       \ "http"
    37 / premiumize.me
       \ "premiumizeme"
    38 / seafile
       \ "seafile"

## Ejemplo de configuración

Queremos mantener sincronizada nuestra carpeta /home/javier/backups con otra carpeta SFTP en otro servidor al cual tenemos acceso por SFTP.

* Ejecutamos `rclone config` y creamos un nuevo remoto seleccionando la opción `n) New remote`
* Asignamos un nombre a ese remoto por ej. backs
* Seleccionamos el tipo 12 correspondiente a SSH/SFTP
* terminamos el asistente introduciendo los valores SFTP usuario, password y host.
 
Ahora podremos ejecutar un ls sobre el remoto para ver los ficheros que hay:

    rclone ls backs:/
    
O podremos sincronizar una carpeta con ese remoto con un comando similar a

    rclone sync /home/javier/backups/ backs:/.local/maquinalocal    
    
