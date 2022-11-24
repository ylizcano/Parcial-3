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

## Contrucción del proyecto
Mediante la terminal ejecutamos:
```
make all 
```
Mediante make se  ejecuta una regla llamada "all" desde un archivo en el directorio actual llamado "Makefile". Esta regla  llama al compilador para que compile el código fuente en binarios.

## Análisis Resultados

- Para un mejor rendimiento se le pueden indicar las variables a Cython para que pueda generar codigo mas optimo,
estas pueden ser declaradas de tres formas diferentes: **def, cpdef y cdef**.
- El archivo setup.py es necesario para generar la extensión de cython al compilarlo,
luego de esto se observa que el tiempo de respuesta de cython es mas optimo que el de python.

