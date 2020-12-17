
##No se pueden subir imagenes a WordPress

Aparece un error parecido al siguiente:

“Unable to create directory /wp-content/uploads//. Is its parent directory writable by the server?”


!!! warning
    Atención: Por ahí he visto muchos artículos que dicen “cambia los permisos a 757 o 777”.  No recomiendo en absoluto eso…

Chequear que usuario ejecuta Apache:

En el caso de ubuntu server, está escrito en  /etc/apache2/envvars y dice algo como:
    
    export APACHE_RUN_USER=www-data
    export APACHE_RUN_GROUP=www-data

Vemos que el grupo, en este caso,  es www-data.

Se crea el directorio para las imágenes:

    $ mkdir /wp-contents/uploads

Se cambia el grupo propietario de la carpeta a www-data 
(-R de recursive, también a todos los archivos que contenga) :

    $ chgrp -R www-data /wp-contents/uploads
        
    $ chmod g+w /wp-contents/uploads

    o si lo prefieres:
        
    $ chmod 775 /wp-contents/uploads

Cambiar el último dígito de los permisos a 7 es peligroso porque cualquier usuario podría editar los ficheros.