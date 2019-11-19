# git

## Ignorar Ficheros y directorios

Para ignorar ficheros y directorios desde el principio, símplemente hay que agregar el patrón o nombre de ficheros o carpetas que se quieren ignorar en un fichero llamado **`.gitignore`** ubicado en la raiz del proyecto. También podría haber un fichero **`.gitignore`** en cada carpeta especificando los items que no queremos seguir en esa carpeta.

!!!NOTE "Nota"
    Las reglas en el fichero .gitignore son válidas solo si los ficheros o carpetas que queremos ignorar, no han sido agregados anteriormente al repositorio. Para ignorar esos ficheros deberemos hacer lo siguiente:

    ```bash
    git rm -r --cached nombrecarpeta
    git commit -m "Eliminada la carpeta nombrecarpeta" 
    git push origin master
    ```