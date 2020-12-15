# Configurar PostgreSQL para permitir conexiones remotas

Por defecto, PostgreSQL solo permite conexiones desde el localhost a través del puerto 5432. 
    
    netstat -nlt
     Conexiones activas de Internet (solo servidores)
     Proto  Recib Enviad Dirección local         Dirección remota       Estado      
     tcp        0      0 0.0.0.0:10000           0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:5940          0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.1.1:53            0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:631           0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:5432          0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:25            0.0.0.0:*               ESCUCHAR   
     tcp        0      0 0.0.0.0:17500           0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:17600         0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:17603         0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:3306          0.0.0.0:*               ESCUCHAR   
     tcp        0      0 127.0.0.1:587           0.0.0.0:*               ESCUCHAR   
     tcp        0      0 0.0.0.0:5900            0.0.0.0:*               ESCUCHAR   
     tcp6       0      0 :::10000                :::*                    ESCUCHAR   
     tcp6       0      0 :::80                   :::*                    ESCUCHAR   
     tcp6       0      0 ::1:631                 :::*                    ESCUCHAR   
     tcp6       0      0 :::17500                :::*                    ESCUCHAR   
     tcp6       0      0 :::5900                 :::*                    ESCUCHAR  

Para cambiar este comportamiento por defecto, editamos el fichero de configuración de PostgreSQL que en Ubuntu Server está ubicado en la carpeta /etc/postgresql/ ….

    nano /etc/postgresql/9.3/main/postgresql.conf
    
En la línea donde pone

    listen_addresses = 'localhost'
    
lo cambiamos por 
    
    listen_addresses = '*'
    
Y reiniciamos postgreSQL con el comando

    sudo service postgresql restart

También ha de modificarse el fichero pg_hba.conf en la misma carpeta agregando una linea como la siguiente (Ver los comentarios dentro del fichero para mas información)

    host     all     all     192.168.1.0/24     md5

    