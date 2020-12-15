# Tips Odoo / Contabilidad

## Cierre de años fiscales
No es recomendable cerrar años fiscales, en todo caso periodos. Una vez cerrado solo puede abrirse trasteando en la base de datos, cambiando en la tabla account_fiscal_year el campo state a "draft" y entonces desde el interface abrir el periodo necesario. Una vez cambiado lo que sea volver a cerrar poniendo el estado "done"

##  Devolución recibo SEPA y pagado de nuevo
Fuente: http://groups.google.com/group/openerp-spain-users/t/b601313e2a20d8ad?utm_source=digest&utm_medium=email

Tras experimentar con lo que la gente propone por la web y darle vueltas,
vuelvo a dejar aquí lo que creo que es la mejor solución
 
Partimos de la base que hemos cobrado ya la remesa de recibos a clientes, y
en el nuevo extracto que descargamos, vemos que un cliente ha devuelto un
recibo, ¿cómo procedemos a dejar la factura abierta sin tener que romper
la conciliación de toda la remesa de pago?

En primer lugar vamos a extractos bancarios, buscamos el apunte de la
devolución y contabilizamos a 430, nos aseguramos que ponga el nombre de la
empresa en la referencia para futura ayuda. Además podemos ir al nuevo
asiento creado y nos aseguramos que en los apuntes indique el nombre de la
empresa que ha devuelto el recibo en caso de que no se haya introducido
automáticamente.

Vamos la ficha del cliente, entramos en apuntes contables y buscamos el
asiento de la factura con el pago (ambos tienen la misma referencia de
conciliación), seleccionamos ambos apuntes y rompemos la conciliación: ya
tenemos la factura abierta

Por último cuando el cliente vuelva a pagar ya podemos conciliar el
nuevo apunte en el extracto bancario con la factura que ya la teníamos
abierta

## Devolución del IRPF
1º. Al DEVENGARSE el derecho a la devolución:
(4709) a (636)
2º. Al PERCIBIRSE la devolución:
(572) a (4709)
3º. Al CIERRE del ejercicio:
(636) a (129)
