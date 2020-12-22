# Sitio web

Este es el repositorio principal de mi sitio web ubicado en https://www,javieranto.com

En la rama master se encuentran los fuentes y en la rama gh-pages se encuentra el sitio estático en HTML

Mi sitio funciona de la siguiente manera: en mi máquina local tengo un repositorio git con la rama master, yo voy creando o modificando notas, de vez en cuando hago un commit y esto dispara el flujo ubicado en la carpeta .github/workflows lo cual genera de forma automática el sitio en HTML en la rama gh-pages.

Usando un webhook proporcionado por el panel de control de mi alojamiento (Plesk Obsydian) cada vez que la rama gh-pages se genera, Plesk copia automáticamente esta rama en mi carpeta de alojamiento. 

Y así es como se hace la magia

dale un vistazo

https://www.javieranto.com