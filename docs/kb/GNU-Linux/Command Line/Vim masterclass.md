#Vim masterclass

Chuleta: http://www.viemu.com/vi-vim-cheat-sheet.gif

`vi`

`vim` → vi Improved

en el modo mas simple hacemos
    
    vim fichero

Tenemos una barra de estado donde se indica columna, linea, caracter y porcentaje del documento.

##Modos

    Modo comando: [ESC]
    Modo insercion: [I]

    :w write
    :q quit
    :wq = :x o shift + zz

##Búsquedas
    / 
    /st
    /^al → empieza por al
    /.al$ → acabe en al

##Navegar
Si hemos arrancado vim a pelo desde la linea de comandos sin pasarle ningún archivo 

    :w fichero o /ruta/fichero/absoluta/ → escribe en el archivo especificado
    :37 → va a la linea 37 
    :$ → va a la última línea
    :1 → va a la primera línea



##Edición
    i = insert mode
    Esc = command mode 
    v = visual mode
    a = append + modo inserción
    O = open above
    o = open new line below

    dd = borra linea
    d4d = borra 4 lineas
    4dd = borra 4 lineas
    r = replace
    x = suprimir 
    4x = supr x 4
    yy = copia linea
    3yy = copia 3 lineas
    y3y = copia 3 lineas
    p = (paste) pega linea(s)
    4p = paste x 4 
    u = undo (infinitos)
    Crtl + r = redo
    Ctrl + n = autocompleta palabras ::
    /algo = busca "algo" 

    Shift + j = join lines 


    :1 = va a la linea 1
    :5341 = va a la linea 5341 
    :$ = va a l final del file == Shift + g

    :w = write
    :wq = write & quit 
    :x = write & quit
    Shift + zz = write and quit
    :new filename = open file (horizontal split)
    :vsplit filename ( vertical split )(Crtl+ww cambia de fichero)
                                (Crtl+w2+ añade 2 lineas a esa ventana de fichero)
                                (Crtl+w3- resta 3 lineas a esa ventana de fichero)
    :syntax on ( activa syntax highligh, resaltado colores ) 
    :syntax off     ( :syn off / :syn on ) 
    :set ic
    :set number     ( :set nu / :set nonu )
    :set nonumber
    :! <command> -> ejecuta comando, muestra la salida por pantalla y vuelve a vim
    :.! <command>-> ejecuta comando e inserta la salida del mismo en vim 

    :% s/a/b/g
    :. s/a/b/
    :,+6 s/^/#/

##VIM autocomplete trick ;) 

1. abre con vim un fichero ( vim vimpower.php ) 
2. :new /usr/share/vim/vim74/syntax/php.vim 
3. :hide 
4. a programar! ;) Pulsa Crtl+n para autocompletar cualquier función! 

!!! note "Nota:"
    Podeis hacer esto con cualquier lenguaje de programacion del que vim  tenga la sintaxis de colores definida. Si no lo encontrais ( cosa rara  ), buscarlo en internet o en la pag de vim.org. Si nos venimos arriba, también podemos hacernos  un esquema de color custom ;) 

!!! note "Nota:"
    Es posible que el path de `/usr/share/vim/vim72/syntax/`... pueda variar dependiendo de la versión de vim que tengamos instalada y/o de la distro de Linux.

Sino siempre podeis descargaros Netbeans ;)

Disponeis de versiones graficas tambien para vim en Windows y Mac, gvim, kvim.

Otros editores cool: Sublime3, Brackets, Atom, notepadqq, notepad++ (solo para win ),...

