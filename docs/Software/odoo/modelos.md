# Creación de Modelos

Fichero dentro de la carpeta models en minúscula separado por _

/models/account_analytic_line.py

En el código, se usa [PascalCase](http://wiki.c2.com/?PascalCase) 
en los nombres de clase, como podemos ver en esta definición, y se sigue 
manteniendo el nombre en singular:

```python
# -*- coding: utf-8 -*-

from odoo import api, fields, models, _
from math import copysign

class AccountAnalyticLine(models.Model): 
    ...

```

El nombre del modelo va en minúsculas y en singular, tal como vemos en la 
definición de sale_order.py


```python
# -*- coding: utf-8 -*-

from odoo import api, fields, models, _
from math import copysign

  class SaleOrder(models.Model):
    _name = "sale.order" --> Nombre del modelo en minúscula y singular
    _inherit = ['portal.mixin', 'mail.thread', 'mail.activity.mixin']
    _description = "Sale Order"
    _order = 'date_order desc, id desc'

    ...

```


