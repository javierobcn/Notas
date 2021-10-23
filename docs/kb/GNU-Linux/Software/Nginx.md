# Nginx
Pronunciado en inglés «engine X», Nginx es un servidor web/proxy inverso ligero de alto rendimiento y un proxy para protocolos de correo electrónico

Es un software libre y de código abierto, licenciado bajo la Licencia BSD simplificada. Es multiplataforma, por lo que corre en sistemas tipo Unix (GNU/Linux, BSD, Solaris, Mac OS X, etc.) y Windows.

Nginx se utiliza en millones de sitios web tan populares como WordPress, Netflix, Hulu, GitHub y hasta partes de Facebook.

## Tips

### Qué versión de Nginx hay instalada
```
/usr/sbin/nginx -v

```
Tras lo cual nos dirá algo como:
```
nginx version: nginx/1.14.2
```

### Testear la configuración de nginx y ver mensajes de error

```
/usr/sbin/nginx -t

```
### Cómo habilitar el uso TLS 1.2 / 1.3

TLS es el acrónimo de "Transport Layer Security". Se trata de protocolos criptográficos diseñados para proporcionar seguridad en las comunicaciones de red. TLS es utilizado por sitios web y otras aplicaciones como mensajería instantánea, correo electrónico, navegadores web, VoIP y, en general,para proteger todas las comunicaciones entre el servidor y el cliente. En esta página se explica cómo habilitar y configurar Nginx para que utilice únicamente las versiones TLS 1.2 y 1.3.

Basta con editar el archivo nginx.conf o el archivo de host virtual, o el snippet de código correspondiente al ssl

```
nano /etc/nginx/snippets/ssl.conf
```

y cambiar las lineas

```
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;


```

Guardar el fichero y reiniciar nginx con el comando

```
sudo service nginx restart
```

Puedes comprobar en esta dirección el funcionamiento de TLS en tu servidor nginx

https://www.ssllabs.com/ssltest/index.html


### Fuentes
https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/
