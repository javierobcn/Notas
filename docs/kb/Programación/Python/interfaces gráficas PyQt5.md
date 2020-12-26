# PyQt 5

Creamos un entorno virtual, lo activamos e instalamos

```bash
cd ~
mkdir pyqt5
cd pyqt5
virtualenv -p python3 env
source env/bin/activate
env/bin/pip3 install pyqt5
```

## Qt Designer

Es una herramienta complementaria que no viene instalada por defecto, debemos instalarla por separado

### Instalación de Qt Designer en Linux

```bash
env/bin/pip3 install PyQt5-tools
```

Dentro de la carpeta ```/env/lib/python3.6/site-packages/qt5_applications/Qt/bin``` tendremos el ejecutable ```designer```

### Componentes de la interfaz

Los elementos de la interfaz se llaman widgets y heredan todos de la clase QWidget, algunos de los mas usados

* QPushButton: setText(), setIcon(), SetEnabled(), clicked(),etc.
* QRadioButton: isChecked(), setChecked(),setText(), toggled()
* QCheckBox:
* QListWidget: addItem(), currentItem(), sortItems(), etc
* QComboBox:
* QLineEdit:
* QTextEdit:
* QLabel:

QApplication: Es el punto de entrada a toda app Qt, administra toda la GUI, configuraciones... es lo que se ejecuta realmente.
QMainWindow: Es la ventana principal y donde se van a colocar el resto de widgets. Puede no existir en interfaces que solo tengan cuadros de dialogo.

Al crear interfaces con Qt Designer se genera un archivo con extension .ui que es un XML.

Este archivo luego lo cargaremos en nuestro código Python para agregarle la lógica.


### Cargando el interfaz y agregando eventos

```python
from PyQt5 import QtWidgets, uic

class MainWindow(QtWidgets.QMainWindow):
    
    def __init__(self):
        super(MainWindow,self).__init__()
        self.ui = uic.loadUi('./project/MainWindow.ui',self)
        self.ui.pushButton.clicked.connect(self.btnClicked) # connecting the clicked signal with btnClicked slot

    def btnClicked(self):
        self.ui.plainTextEdit.setText("Button Clicked")


app = QtWidgets.QApplication([])
miventana = MainWindow()
miventana.show()
app.exec_()
```
