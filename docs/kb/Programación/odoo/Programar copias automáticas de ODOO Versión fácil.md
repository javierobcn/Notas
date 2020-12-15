#Programar copias automáticas de ODOO Versión fácil

Hay un módulo de OCA que realiza copias de seguridad de forma automática según el propio programador de tareas desde ODOO. Los backups incluyen la base de datos y el «Filestore».

Antes de instalar el módulo, ejecutar en el servidor
   
    pip3 install pysftp==0.2.8

Instalar este módulo en Odoo
https://github.com/OCA/server-tools/tree/12.0/auto_backup

La configuración del módulo está en «Ajustes», «Técnico», «Estructura de la base de datos», «Copias de seguridad automatizadas»