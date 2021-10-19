# Zonas horarias
## Ver la zona horaria actual

```
timedatectl
```

La zona horaria del sistema se configura con un enlace a un binario ubicado en /usr/share/zoneinfo. Puede verse la zona que se ustá usando chequeando el path al que apunta el enlace

```
ls -l /etc/localtime
```

## Cambiar la zona horaria

Antes de cambiar la zona horaria debemos encontrar el nombre para la zona que queremos usar. Los nombres usan un patrón "Región/Ciudad" . Para listar las zonas disponibles usamos el comando 

```
timedatectl list-timezones
```

Una vez identificado el nombre de la zona que queramos usar, ejecutamos el comando

```
sudo timedatectl set-timezone Europe/Madrid
```
