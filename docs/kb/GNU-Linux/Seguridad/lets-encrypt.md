##Certificados SSL Let’s Encrypt

### Receta para instalar y renovar automáticamente un certificado SSL Let’s Encrypt

    # Habilitar módulos necesarios de apache
    a2enmod ssl
    a2enmod proxy
    a2enmod proxy_http
    a2enmod headers
    a2enmod expires
    a2enmod rewrite
     
    # Para Odoo Configurar sitio apache con reverse proxy
     
    #Agregar repositorios
    sudo add-apt-repository ppa:certbot/certbot
     
    #Actualizar repositorios
    sudo apt-get update
     
    # Instalar certbot
    sudo apt-get install python-certbot-apache
     
    # Obtener certificado e instalar (cambiar example.com)
    sudo certbot --apache -d example.com -d www.example.com
     
    # programar en el cron la linea
    crontab -e para el root
    15 3 * * * /usr/bin/certbot renew --quiet
     
    # para que cada dia a las 3:15 de la madrugada intente renovar el certificado