## Redirigir dominio en Apache example.com a www.example.com

En ocasiones interesa que, si un usuario o motor de búsqueda intenta acceder al dominio sin las www, por ej. example.com, Apache le redireccione a www.example.com

Para estos casos, el redireccionamiento 301 es el más adecuado.

La Redirección 301 consiste en configurar el servidor web para que, cuando llegue el robot del buscador, o cualquier otra visita, ésta sepa que la página se ha movido definitivamente a otra nueva dirección (URL).

Mediante este redireccionamiento, se traspasarán al mismo tiempo los valores de PageRank y de backlinks que ya disponíamos en nuestra vieja URL.

Este número 301 se trata realmente de un 'estado' del servidor web. Al igual que nos encontramos con los mensajes '404 Not Found' o '500 Internal Server Error', el '301 Moved Permanently' se trata de un estado de los estándares del protocolo HTTP.

En el archivo de configuración del sitio web, normalmente ubicado en la ruta /etc/apache2/sites-available buscamos la clave VirtualHost y agregamos al final

    <VirtualHost *:80>
    ...
      RewriteEngine On
      RewriteCond %{HTTP_HOST} ^example\.com
      RewriteRule ^(.*)$ http://www.example.com$1 [R=permanent,L]
    ...