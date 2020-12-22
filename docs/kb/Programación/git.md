# git

## Cambiar el mensaje de un commit ya realizado

Si ya hiciste un commit y quieres cambiar el mensaje, usa `git commit --amend`, esto va a abrir el editor donde puedes cambiar el mensaje

```
Mensaje del commit

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
```

Cambia el mensaje y guarda el archivo. Para asegurarte que el cambio se realizó correctamente, puedes hacer `git log` y revisar que el mensaje del commit se haya actualizado.

```
commit id
Author: Fulano
Date:   fecha

    Nuevo Mensaje
```

Si ya habías hecho push de ese commit, haz `git push -f` para que se actualice.

## Ignorar Ficheros y directorios

Para ignorar ficheros y directorios desde el principio, símplemente hay que agregar el patrón o nombre de ficheros o carpetas que se quieren ignorar en un fichero llamado **`.gitignore`** ubicado en la raiz del proyecto. También podría haber un fichero **`.gitignore`** en cada carpeta especificando los items que no queremos seguir en esa carpeta.

!!!NOTE "Nota"
    Las reglas en el fichero .gitignore son válidas solo si los ficheros o carpetas que queremos ignorar, no han sido agregados anteriormente al repositorio. Para ignorar esos ficheros deberemos hacer lo siguiente:

    ```bash
    git rm -r --cached nombrecarpeta
    git commit -m "Eliminada la carpeta nombrecarpeta" 
    git push origin master
    ```

!!!NOTE "Plantillas"
    Puedes descargar plantillas para el fichero .gitignore y para distintos lenguajes de programacion desde https://github.com/github/gitignore/blob/master/README.md

    

## Dejar de seguir fichero y borrar del repositorio

En ocasiones subes al repositorio un fichero de configuración del entorno de desarrollo y quieres borrarlo del repositorio, a la vez que lo conservas en local  y dejas de realizar seguimientos del fichero. Para borrarlo del repositorio ejecutar el comando:
    
    git rm --cached nombre-archivo

Luego puede agregarse al fichero .gitignore

y por último subir los cambios


## Acciones GitHub

Las acciones de GitHub ayudan a automatizar tareas dentro del ciclo de vida del desarrollo. Las acciones de GitHub están controladas por eventos, lo que significa que pueden ejecutarse una serie de comandos después de que haya ocurrido un evento específico. Por ejemplo, cada vez que alguien crea una solicitud push/pull en un repositorio, puede ejecutarse automáticamente un comando que ejecuta un script de prueba de software.

### Acción de ejemplo GitHub: Publicar blog cada vez que se hace un push

Cada vez que se hace un push en el repositorio de este blog, se genera de forma automática este sitio web 

https://github.com/javierobcn/Notas/blob/master/.github/workflows/main.yml

```yml
# This is a basic workflow to help you get started with Actions

name: documentation

# Controls when the action will run. 
on:
  # Triggers the workflow on push or pull request events but only for the master branch
  push:
    branches: [ master,main ]
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
            fetch-depth: 0

      - name: Set up Python runtime
        uses: actions/setup-python@v2
        with:
          python-version: 3.x

      - name: Install Python dependencies
        run: |
          pip install mkdocs-material
          pip install mkdocs-minify-plugin>=0.3 \
            mkdocs-redirects>=1.0 \
            mkdocs-awesome-pages-plugin>=2.4.0 \
            mkdocs-blog-plugin>=0.25 \
            mkdocs-material-extensions>=1.0.1 \
            pyembed-markdown>=1.1.0 \
            mkdocs-git-revision-date-localized-plugin
             
      - name: Deploy
        run: |
          mkdocs gh-deploy --force
          mkdocs --version
```