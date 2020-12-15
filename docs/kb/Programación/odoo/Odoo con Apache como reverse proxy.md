# Odoo con Apache como reverse proxy

Una vez que tenemos la instancia de odoo corriendo en el puerto standard 8069 podemos acceder a Odoo utilizando un nombre de dominio y sin poner el número de puerto en la URL. Para ello utilizaremos Apache como Proxy reverso.

Primero instalamos Apache2 y habilitamos los módulos necesarios:

Una vez hecho esto, creamos un fichero de configuración web para nuestro dominio:

    nano /etc/apache2/sites-available/your_domain.conf
    
Y dentro del fichero ponemos lo siguiente:

    <VirtualHost *:80>
    ServerName your_domain.com
    ServerAlias www.your_domain.com
      
    ProxyRequests Off
    <Proxy *>
    Order deny,allow
    Allow from all
    </Proxy>
      
    ProxyPass / http://your_domain.com:8069/
    ProxyPassReverse / http://your_domain.com:8069/
    <Location />
    Order allow,deny
    Allow from all
    </Location>
    </VirtualHost>

Activamos el sitio en Apache:
    
    a2ensite your_domain.conf

(También podría utilizarse el siguiente comando para activar el sitio)

    ln -s /etc/apache2/sites-available/your_domain.conf /etc/apache2/sites-enabled/your_domain.conf
    
Reiniciamos apache

    service apache2 restart
    
Es todo, tu sitio debería funcionar y solo quedaría asegurar el sitio apache con un certificado SSL de Let’s encrypt