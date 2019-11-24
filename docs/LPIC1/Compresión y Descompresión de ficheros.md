#Compresión y Descompresión de ficheros

A grandes rasgos, la compresión se basa en una matriz donde se indica, que hay, donde y cuantas veces. Es algo mas complejo pero el principio es el mismo que el de los ficheros JPG

##Formatos
ZIP → unzip, zip
RAR → unrar, rar
GZ BZ → tar

###GZIP
gzip -d nombrefichero ( descomprime)
gzip -c  (comprime) 

###BZIP2
BZIP es un poco mas lento pero comprime mas.
bzip -d 
bzip -c 

###Parámetros comunes para TAR
tar -xzvf filename.tar.gz
tar -cf backup-etc-`date +%Y%m%d`.tar /etc/

x depak c Pack
z gzip j bzz
v Verbose
f trabaja con ficheros. Normalmente TAR trabajaba con cintas.
p conserva los permisos al comprimir

####TAR compressing
tar -cvfp filename.tar <file(s)>
tar -cpzvfp filename.tar.gz <file(s)>
tar -cpjvfp filename.tar.bz2 <file(s)>

####TAR Decompressing
tar -xvf filename.tar 
tar -xzvf filename.tar.gz 
tar -xjvf filename.tar.bz2

ZIP
unzip filename.zip


