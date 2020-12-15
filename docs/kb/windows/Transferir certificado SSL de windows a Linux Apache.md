# Transferir certificado SSL de windows a Linux Apache


Transferir certificado SSL de windows a Linux Apache

Después de investigar un poco he conseguido transferir un certificado SSL desde un windows server 2008 R2 a un Apache2 en Linux Ubuntu. Aquí va la receta…

Primero se exporta el certificado desde el IIS en el servidor windows a formato PFX, esto es algo que siempre deberías hacer para tener una copia de seguridad del certificado.

Ejecutar mmc.exe
Clic en el menú ‘Consola’ y selecciona ‘Agregar/Quitar complemento’.
En la lista de complementos selecciona el complemento «Certificados» y haces click en «Agregar»
Selecciona ‘Cuenta de equipo’y haz click en ‘Siguiente’
Selecciona ‘Equipo Local’ y click en Finalizar.
Clic en Aceptar
Expandir el menú para ‘Certificados’ y click en la carpeta ‘Personal’.
Botón derecho en el certificado que quieras exportar y seleccionas «Todas las tareas > Exportar»

Aparece un asistente. Asegúrate de chequear la opción para incluir la clave privada y continúa a través del asistente hasta que obtengas un fichero .PFX

A continuación ejecuta, desde Linux, el comando openssl para extraer la clave privada y el fichero con el certificado.

    # Exportar la clave privada desde el fichero pfx
    openssl pkcs12 -in filename.pfx -nocerts -out key.pem
    # Exportar el certificado desde el fichero pfx
    openssl pkcs12 -in filename.pfx -clcerts -nokeys -out cert.pem
    # Esto elimina la frase de seguridad de la clave privada para que Apache no la solicite cuando se inicie.
    openssl rsa -in key.pem -out server.key
    
Ahora, un paso extra para hacer que el certificado funcione, necesitamos incluir en el fichero de configuracion del host virtual las siguientes lineas:

SSLEngine on
SSLOptions +StrictRequire
SSLCertificateFile /path/to/certificate/cert.pem
SSLCertificateKeyFile /patch/to/key/server.key

El fichero de host virtual estará localizado normalmente en “/etc/apache2/sites-available/virtualhostname.conf”
reiniciar apache con el comando

sudo apache2ctl restart