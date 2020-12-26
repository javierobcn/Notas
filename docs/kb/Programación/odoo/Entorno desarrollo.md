# Estandarizar entornos

Es muy aconsejable que los entornos de producción y de desarrollo sean lo mas similares posible. La estandarización es muy util en las tareas de mantenimiento y es muy aconsejable para facilitar las tareas del dia a dia.

## Como preparar un entorno virtual Python

!!!NOTE "Nota"
    Es necesario tener instaladas las extensiones de desarrollo de python que son instaladas con el comando `sudo apt-get install python3-dev`

Para crear el diseño propuesto necesitamos realizar los siguientes pasos:

- Crear un directorio por instancia

```bash
mkdir ~/odoo-dev/nombreproyecto
cd ~/odoo-dev/nombreproyecto
```

- Crear un entorno virtual Python con el comando `virtualenv` en un subdirectorio llamado `env`

```bash
virtualenv -p python3 env
```

- Crear algunos subdirectorios comunes:

```bash
mkdir src local bin filestore logs`
```

- Clonar Odoo e instalar los requisitos indicados en el fichero requisites.txt de Odoo

```bash
git clone https://github.com/odoo/odoo.git src/odoo --depth 1 --branch 12.0
env/bin/pip3 install -r src/odoo/requirements.txt
```

!!!NOTE "Nota"
    el parámetro `--depth 1` en la orden `git clone` hace que la descarga del repositorio de odoo sea el código actual sin incluir la historia de los commits, por otra parte el parámetro `--branch` especifica que rama queremos descargar, en este caso la rama 12.0, si se omite descargará la rama master que corresponde a la última versión

!!!NOTE "Nota"
    Pueden instalarse módulos adicionales en el entorno virtual con el comando `env/bin/pip3 install ovh` o módulos desde git directamente con `env/bin/pip3 install git+https://github.com/botlabio/pywhois.git`

- Crear el siguiente script y guardarlo como `bin/odoo`

```bash
#!/bin/sh
ROOT=$(dirname $0)/..
PYTHON=$ROOT/env/bin/python3
ODOO=$ROOT/src/odoo/odoo-bin
$PYTHON $ODOO -c $ROOT/projectname.cfg "$@"
exit $?
```

- Generar un módulo dummy

```bash
mkdir -p local/dummy
touch local/dummy/__init__.py
echo '{"name":"dummy","installable":False}' > local/dummy/__manifest__.py
```

- Generar un fichero de configuración para la instancia

```bash
bin/odoo --stop-after-init --save \
--addons-path src/odoo/odoo/addons,src/odoo/addons,local \
--data-dir filestore
```

- Generar un fichero `.gitignore` que excluya algunos directorios

```bash
.*
!.gitignore
*.py[co]
*~
/env/
/src/
/filestore/
/logs/
```

- crear un repositorio git y agregar los ficheros:

```bash
git init
git add .
git commit -m "initial version de projectname"
```

- Activar el entorno virtual

```bash
    source env/bin/activate
```

- Desactivar el entorno virtual

```bash
deactivate
```
