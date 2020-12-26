# MailCatcher

MailCatcher es un servicio que ejecuta un servidor SMTP que captura todos los mensajes enviados y los muestra en una interfaz web. Al ejecutar el servicio, solo tienes que redirigir el tráfico de tus envíos de emails a smtp://127.0.0.1:1025 en vez de a tu servidor SMTP

Para luego poder comprobar los emails que han llegado simplemente tenemos que acceder a <http://127.0.0.1:1080>.

<https://mailcatcher.me/>

## Imagen de docker

```bash
docker run -d -p 1080:1080 -p 1025:1025 --name mailcatcher schickling/mailcatcher
```

## Restart imagen de docker

```bash
sudo docker restart mailcatcher
```
