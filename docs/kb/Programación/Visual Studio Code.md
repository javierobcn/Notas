# Visual Studio Code

## Errores con los imports de Odoo

Si te aparecen errores con los imports de Odoo, te los marca como desconocidos y no los encuentra es debido a Pylint

Como alternativa a Pylint, Flake8 si que encuentra los imports y parece que solo muestra feedback como imports no usados y espacios en blanco alrededor.

In Visual Studio Code, ensure you're at a root prompt in the terminal, press Ctrl+Shift+P to open the palette, search/choose "Python: Select Linter", and choose "flake8" to use it instead of Pylint.

https://github.com/PyCQA/pylint/issues/3721#issuecomment-694891033
