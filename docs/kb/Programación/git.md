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
