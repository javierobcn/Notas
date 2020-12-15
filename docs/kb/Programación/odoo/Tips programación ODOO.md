# Tips programación ODOO

## Fechas y horas

fields.Datetime.from_string()

## Atributos de modelo
 _name
_description
_order
_rec_name
_table
_inherit
_inherits

## Vistas


## Codigo ORM
### Ejecutar una función de otro modelo
#### Ejecutar la función action_confirm del modelo sale.order:
self.env['sale.order'].browse([self.order_id.id]).action_confirm()

## Vistas
### Hacer un elemento visible solo para administradores
 para hacer algo visible solo a admins, se agrega este parámetro al elemento en cuestión: groups="base.group_no_one"

### Cambiar un atributo de un elemento HTML por herencia
En el último xpath puede verse como cambia el atributo class del grid

<template id="products_categories" inherit_id="website_sale.products" active="False" customize_show="True" name="Product Categories">
  <xpath expr="//div[@id='products_grid_before']" position="inside">
      <ul class="nav nav-pills nav-stacked mt16">
          <li t-att-class=" '' if category else 'active' "><a t-att-href="keep('/shop',category=0)">All Products</a></li>
          <t t-foreach="categories" t-as="c">
              <t t-call="website_sale.categories_recursive"/>
          </t>
      </ul>
  </xpath>
  <xpath expr="//div[@id='products_grid_before']" position="attributes">
      <attribute name="class">col-md-3 hidden-xs</attribute>
  </xpath>
  <xpath expr="//div[@id='products_grid']" position="attributes">
      <attribute name="class">col-md-9</attribute>
  </xpath>
</template>



## Reports
### Odoo 10 necesita una version especifíca para wkhtmltopdf 
https://wkhtmltopdf.org/downloads.html -- > 0.12.1
#### se desinstala la versión que haya con
sudo apt-get remove --purge wkhtmltopdf
#### y se instala la version descargada con gdeb desde nautilus o a mano con comandos
sudo apt-get install gdebi-core 
sudo gdebi wkhtmltox-0.12.1_linux-trusty-amd64.deb

### debug reports en máquina de desarrollo
Agregar el par clave/valor a los parámetros de sistema (Modo desarrollador config-técnico-parametros-parametros del sistema:

Clave 	web.base.url
Valor 	http://0.0.0.0:8069

Para evitar estar haciendo esto cada vez que se descarga una copia a la maquina de desarrollo, puede crearse el parámetro reports.url que será leido especificamente para los reports
Clave  report.url
Valor  http://localhost:8069

(Fuente)
https://www.odoo.com/documentation/10.0/howtos/backend.html#reference-backend-reporting-printed-reports-pdf-without-styles

## Entorno de desarrollo
### Pycharm
#### Instalar Pycharm desde repositorios
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -sc)-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'

wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -

sudo apt-get update && sudo apt-get install pycharm

## Documentación
http://odoo-new-api.readthedocs.io/en/master/

