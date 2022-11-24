import time
import AlgoritmoGenetico
import AlgoritmoGenetico_C

time_span = 400
n_steps = 2000000

"""Definición de experimento
Reducción de ruido gausiano"""


#Se crea un formato para la impresión sobre el fichero
formato_datos = "{:.5f},{:.5f}\n"

for i in range(30):
	#Toma de tiempos para Python
	inicioPy = time.time()
	AlgoritmoGenetico.ejecutar()
	finalPy = time.time() - inicioPy
	
	#Toma de tiempos para Cython
	inicioCy = time.time()
	AlgoritmoGenetico_C.ejecutar()
	finalCy = time.time() - inicioCy
	
	with open("Genetico1.csv","a") as archivo:
		archivo.write(formato_datos.format(finalPy,finalCy))
