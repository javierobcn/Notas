#Kernel

https://www.kernel.org/

`ldconfig -v` → regenera la caché de librerias, Para poder ver algo, activamos el verbose a 1, si no no muestra información

`uname` → muestra “Linux” 

`uname -a` → muestra la versión del kernel, arquitectura …

```
Linux debian 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt25-2 (2016-04-08) x86_64 GNU/Linux
```

`uname -r` → solo muestra la versión del kernel
```
3.16.0-4-amd64
```

3 → Release del Kernel (si es par es stable, si es impar es unstable)

16 → Major Version

0-4 → Revision y patch

amd64 → arquitectura


echo “estoy usando kernel: `uname -r`”


`lsmod` → muestra los módulos del kernel cargados ahora mismo.