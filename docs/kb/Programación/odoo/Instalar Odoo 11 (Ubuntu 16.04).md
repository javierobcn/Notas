# Instalar Odoo 11
Recomendado instalar en Ubuntu 16.04 LTS siguiendo el tuto para crear entornos

## Requisitos de sistema
```bash

sudo apt-get install gcc python3-dev Babel decorator docutils ebaysdk feedparser gevent greenlet html2text Jinja2 lxml Mako MarkupSafe mock num2words ofxparse passlib Pillow psutil psycogreen psycopg2 pydot pyparsing PyPDF2 pyserial python-dateutil python-openid pytz pyusb PyYAML qrcode reportlab requests six suds-jurko vatnumber vobject Werkzeug XlsxWriter xlwt xlrd libsasl2-dev python-dev libldap2-dev libssl-dev postgresql-server-dev-all libpq-dev 
```

## Requisitos de Odoo 11
```bash

env/bin/pip3 install -r src/odoo/requirements.txt
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less@3.0.4 less-plugin-clean-css
```
Probar con lo anterior y si no funciona, con esto: sudo npm 

```
install -g less less-plugin-clean-css
sudo apt-get install node-less

cd src/odoo
sudo wget https://pypi.python.org/packages/a8/70/bd554151443fe9e89d9a934a7891aaffc63b9cb5c7d608972919a002c03c/gdata-2.0.18.tar.gz
```
### Wkhtmltopdf
Para Ubuntu 12 es necesaria esta versión
wkhtmltox-0.12.1_linux-precise-amd64.deb

Para instalarla, la descargamos y 
```
sudo dpkg -i wkhtmltox-0.12.1_linux-precise-amd64.deb
```
Instalamos las dependencias
```
sudo apt-get install 
```