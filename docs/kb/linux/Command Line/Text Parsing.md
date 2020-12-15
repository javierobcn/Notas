#Text Parsing

cat: muestra un fichero entero de ppio a fin por standard output sin paginar

tac: muestra un fichero de fin a ppio al revés

head: muestra las n primeras lineas de un fichero: head -3 /etc/passwd

tail: muestras las n ultimas lineas de un fichero: tail-3 /etc/passwd 

tail -f /var/log/messages: muestra las actualizaciones del fichero en tiempo real.

history | tail -8

more: muestra un fichero paginado + search
less: muestra un fichero paginado pero permite pasar línea a línea + search 

awk: text parsing language (Es un lenguaje de procesamiento)
dpkg -l nos muestra los programas instalados de la A a la Z
dpkg -l |awk {' print $2,$4 '}


cut: corta ficheros de forma longitudinal 
cut -c 1-8 /etc/passwd
cut -c 1,8,2,11  /etc/passwd
cut -d: -f 1,7 (delimitado por “:” y cogiendo campos 1 y 7 

sed: sustituye cadenas de texto Ej: echo hola | sed "s/o/XXX/" 
cut -d: -f 1,7 /etc/passwd |head |sed "s/^/XXX/"

Expresiones regulares para sed: https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html

sed -i file 
tr: translate ( cambia caracteres ) 
diff: muestra diferencias entre ficheros

md5sum: realiza la suma con el algoritmo MD5 de un fichero (No usar para cifrado,para cifrado usar shasum file.a)

xargs:  manipula la salida de un texto que le viene dado mediante STDIN
Howto: http://www.thegeekstuff.com/2013/12/xargs-examples/https://titanpad.com/linux?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+TheGeekStuff+%28The+Geek+Stuff%29
puede usarse para encolumnar resultados:
cat /etc/passwd | cut -d: -f 1 | xargs

sort: ordena resultados 
uniq: elimina duplicados
wc: cuenta palabras, caracteres, bytes o líneas
wc -l /etc/passwd # nº de usuarios del sistema

join: junta ficheros con un campo en comun 
paste: junta lineas de ficheros
split: parte ficheros en N partes de tamaño X : split filename ó split -b 2048 filename

tee: split STDOUT : bifurca la salida de un comando a 2 sitios a la vez, por ej. a un fichero y a la vez a la pantalla.
cat /var/log/daemon.log | tee /tmp/salida.txt
tcpdump -vvv -X -x -n -l -i eth0 | tee /tmp/blabla.txt

od: octal dump : echo “hola que tal :D” | od
hexdump: hexacedimal dump : hexdump -c /etc/passwd

strings: get strings from ANY file ;) sacar cadenas de un fichero aunque sea binario 
strings $(which ls). 

El paquete strings depende de binutils que se instalan con:
aptitude install binutils


file: identifica un tipo de fichero basándose en sus cabeceras
identify: saca datos de ficheros de imagen ( NO saca los meta tags :P ) 

FAMILIA Z* ( aplicable a ficheros comprimidos con gzip ) 
===============(_*_)==========================
zcat
zless
zmore
zgrep
zdiff


GENERAR CSV CON USERS DEL SISTEMA: 
cat /etc/passwd |cut -d: -f1,6,7 |grep -v nologin | sed "s/^/\"/" | sed "s/$/\"/" | sed "s/:/\";\"/g" > filename.csv 

$> libreoffice filename.csv 

root@debian:/home/linux/test#  cat /etc/passwd | cut -d: -f1,3,6 | sed "s/^/\"/" | sed "s/$/\"/" | sed  "s/:/\";\"/g" > users.csv && libreoffice users.csv cat  /etc/passwd |cut -d: -f1,6,7 |grep -v nologin | sed "s/^/\"/" | sed  "s/$/\"/" | sed "s/:/\";\"/g" > filename.csv

Estructura del fichero /etc/passwd
usuario1: nombre de la cuenta
x: clave encriptada
500: UID de la cuenta
501: GID de la cuenta
pepito: Nombre del usuario
/home/pepito: Carpeta home del usuario
/bin/bash:  Interprete de comandos (shell)


nl  <filename> devuelve un fichero con las lineas numeradas
cat -n <filename> devuelve un fichero con las lineas numeradas

grep
buscar cadenas de texto
grep root /etc/passwd --col
grep -i case insensitive

cat passwd | grep nologin --col 
cat /etc/passwd | grep -v "nologin\|/bin/false" con el | hacemos un OR
grep -o solo saca la parte del string que coincide
grep -c cuenta las veces que aparece el string

Muestra en los resultados 5 lineas anteriores y 5 lineas posteriores
grep -5 -i debian /etc/passwd --col

grep -i idiot / en todo el sistema

existe = $(mysql --create-database) if grep exists

^ principio de linea
$ final de linea

grep “^abc”

sustituir:
cat /etc/passwd | cut -d: -f 1,3,6 | sed “s/buscando/sustituir”


Ver los comandos mas usados en el sistema
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10 

Otros intérpretes de comandos
bash sh y csh son los que deberiamos conocer bien
tcsh
zsh
ksh

para ver que shells hay disponibles en el sistema
cat /etc/shells


whereis ls 
nos da el path absoluto de dicho binario y la pagina de manual, mientras que which solo da el path del binario. Esto posibilita realizar scripts para multiples plataformas ya que podemos definir una variable como:
V = `wich ls`
y a partir de eso utilizar esa variable en el path

Tanto whereis como which funcionan porque hay una base de datos del sistema. Esta base de datos se actualiza con el comando updatedb

locate <fichero>  busca un fichero

locate *.mp3
locate *.txt | wc -l

Find
find donde que
	-type f,d,l (tipos de fichero)
	-iname (case insensitive)
	
	-user manolo
	-group sysadmins
	-perms
	-ctime 1 == 24h
	-atime
	-mtime

find /media/iomega -type f -iname autorun.inf -exec rm{}\;
find / -iname *.txt -exec grep -H -i hola '{}' \;
find /etc/ -iname *.mp4

Crear una BD con todos los ficheros y hacer búsquedas:
find / | gzip -c > /root/DBFILES.DAT
function busca { zgrep -i "$1" /root/DBFILES.DAT --color; }



## Ejercicio log parsing: 
Coger logs de apache de cualquier servidor 
y intentar sacar: 

file ejemplo: http://drlinux.cat/tools/horse.log 

-> num de lineas que contiene el fichero 2106
-> numero de IP's distintas que hay 81
-> numero de veces que aparece "robots.txt" 22
-> # de peticiones POST = ==> 4            
    	Que IP's nos han hecho esto? 
188.165.128.164        
-> numero de veces que ha pasado GoogleBot por ese website 51
-> numero de veces que nos han visitado con IEXPLORER  63
-> Cuantos Androids? i iPhones? 463 android | 201 iPhone


egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" horse.log 
cat horse.log | awk {' print $1 '} |sort -u |wc -l
cut -d"-" -f1 horse.log 
-...


grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" horse.log | sort -u | wc -l





