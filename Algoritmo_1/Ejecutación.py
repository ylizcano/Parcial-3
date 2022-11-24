import time
import Canivales_py
import Canivales_C

time_span = 400
n_steps = 2000000

"""Definición de experimento
Reducción de ruido gausiano"""

cani = Canivales_py.Cabernicola()

#Se crea un formato para la impresión sobre el fichero
formato_datos = "{:.5f},{:.5f}\n"

for i in range(30):
	#Toma de tiempos para Python
	inicioPy = time.time()
	cani.ejecutar()
	finalPy = time.time() - inicioPy
	
	#Toma de tiempos para Cython
	inicioCy = time.time()
	Canivales_C.ejecutar_Cavernicola_C()
	finalCy = time.time() - inicioCy
	
	with open("Cavernicola.csv","a") as archivo:
		archivo.write(formato_datos.format(finalPy,finalCy))
