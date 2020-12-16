## Eliminar el pie de los mensajes "Powered by Odoo" o "Impulsado por Odoo"

Según el código:

https://github.com/odoo/odoo/blob/e3f54a78088ab799c8db543c663ea026e7a8b574/addons/sale/models/sale.py#L622

Se usa la vista definida en mail.mail_notification_paynow

Vamos a "Ajustes" - "Técnico" - "Interfaz de usuario" - "Vistas" 

Buscamos mail_notification_paynow y adaptamos a nuestra conveniencia

