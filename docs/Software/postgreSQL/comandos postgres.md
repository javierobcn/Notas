#comandos postgres

```bash

    # Hacer un backup de una base de datos
    pg_dump nombasedatos > ~/ruta/nombrearchivo.sql

    # Restaurar un backup de una base de datos
    psql -U usuario -h host -d database -f /ruta/fichero/copia.sql    

    # Entrar en modo consola
    psql

    # Salir del modo consola
    \q

    
```

