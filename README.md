## Comparativa de rendimiento Cython vs Python
**Cython**
- Es un lenguaje de programación que combina Python con el sistema
  de tipos estáticos de C y C++.
- Es un compilador que traduce el código fuente de Cython a un código fuente C o C++ eficiente.
  Este código fuente se puede compilar en un módulo de extensión de Python o en un ejecutable      
  independiente.


## Instalación

Se utiliza el administrador de paquetes [pip](https://pip.pypa.io/en/stable/) para instalar cython,
y para la compilación se utiliza el comando python3 setup.py build_ext --inplace.


```bash
pip install cython
python3 setup.py build_ext --inplace
```

## Construcción  del proyecto
El proyecto está conformado con dos algoritmos para evaluar su rendimiento, haciendo una comparativa entre Python y Cython.
En las carpetas ```Algoritmo_1``` y ```Algoritmo_2``` se encuentran los ficheros: 
```Ficheros *.py```
```Ficheros *.pyx```
```Ficheros *.csv```
```Makefile```

Mediante la terminal ejecutamos:
```
make all 
```
Mediante make se  ejecuta una regla llamada "all" desde un archivo en el directorio actual llamado "Makefile". Esta regla  llama al compilador para que compile el código fuente en binarios.

## Ejecución del programa

```
python3 ejecutar.py
```
Mediante este comando corremos el proyecto y se da por finalizado el programa. 


