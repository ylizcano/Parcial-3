import matplotlib.pyplot as plt  # Modulo que permite crear visualizaciones estátocas animadas e iteractivas
import numpy as np               # Modulo que da soporte para crear vectores y matrices, junto con una gran colección de funciones matematicas
import math                      # Proporciona acceso a las funciones matemáticas definidas por el estándar C

lista_distancia = list()        # Se crea una lista en donde se guardaran las distancias que tiene las generaciones respecto al objetivo
lista_generaciones = list()     # Se crea una lista en donde se guardaran las generaciones obtenidas en cada iteración.

cdef int x0 = 30
cdef int y0 = 30
cdef int v0 = 100
cdef int PoblacionTotal = 100
cdef int Generaciones = 10
cdef int DistanciaObjetivo = 200

#funcion para representar el movimiento parabolico mediante sus ecuaciones
def movimientoparabolico(x_0, y_0, v_0):

  lista_x = []   #Lista para guardar la posicion en el eje X del movimiento (Distancia horizontal)  
  lista_y = []   #Lista para guardar la posicion en el eje y del movimiento (Altura)

  t=0; g = 9.8   #constantes fisicas usadas en las ecuaciones

  if (y_0 == 0 and x_0 == 0) or x_0 == 0:  #se validan si los parametros recividos son ceros
    angulo = math.radians(1)               #se hace uso de la coleccion de funciones "math" para convertir grados a radianes
  elif x_0 == 0:        
    angulo = math.radians(90)              #se hace uso de la coleccion de funciones "math" para convertir grados a radianes
  else:
    angulo = math.atan(y_0/x_0)            #se hace uso de la coleccion de funciones "math" para obtener el angulo segun  los parametros recividos
  

  while True:
    t += 0.01
    y = -( (1/2) * 9.8 * (t**2) )  + ( v_0 * math.sin(angulo) * t )     #Se genera la ecuacion de la altura del movimiento parabolico
    x = v_0 * np.cos(angulo) * t                                        #Se genera la ecuacion de la posicion horizontal del movimiento parabolico

    if y >= 0:                             #Se valida que la altura obtenida anteriormente sea mayor o igual a 0
      lista_y.append(y)                    #Se añaden las posiciones en Y del movimiento a la lista_y
      lista_x.append(x)                    #Se añaden las posiciones en X del movimiento a la lista_x
    else:
      break

  return (lista_x, lista_y)                #Se retornan las listas de las posiciones X y Y
  
#Metodo para la graficacion de cada lanzamiento "individuo" 
def graficacion_cromosoma(crom = []):

  print('\n')

  plt.figure(figsize=(10,6))       #Tamaño de la grafica

  plt.plot(0,0, marker="*", color="red")    #Alguno elementos decorativos
  plt.plot(DistanciaObjetivo, 0, marker="D", color="blue")    #Nuestro objetivo

  for i in crom:                                              #Se recorren todos los individuos que se recibieron como parametro
    (x1, y1) = movimientoparabolico(i[0], i[1], i[2])         #Se invoca a la funcion de movimiento parabolico
    plt.plot(x1, y1, "--")                                    #Se grafica el individuo

  #Elementos decorativos y de presentacion para la grafica
  plt.xlabel('Distancia (m)')                                 
  plt.ylabel('Altura (m)')
  plt.title('Movimiento Obtenido')
  plt.grid()
  plt.show()
  




#print(cromosoma)                    #Se verifican visualmente los individuos

#graficacion_cromosoma(cromosoma)    #Se grafican los individuos

#Funcion fitness, aqui se defienen quienes son los mas adecuados para la reproduccion, mediante la ecuacion de vuelo t = 2 (vo/g) sen θ,
#nos aseguramos que la funcion sea mas eficiente.
#Esta funcion se debe usar para cada generacion de individuos
def fitness(genotipo):

  global lista_distancia                #Lista de las distancias de la posicion final de cada individio respecto al objetivo

  fitnessList = list()                  #Lista de los distintos porcetajes de fitness de cada individuo
  acum = 0                              #Se requeire para sacar el porcentaje
  for i in genotipo:                                #Por genotipo nos referimos a cada integrante de la poblacion (individuo)
    if (i[1] == 0 and i[0] == 0) or i[0] == 0:      #Se evalua el caso cuando el individuo vale 0
      angulo = math.radians(1)                      #Se convierte a radianes su angulo
    elif i[0] == 0:                                 #Cuando la altura es 0, una vez ha tocado el suelo
      angulo = math.radians(90)                     #Se convierte a radianes su angulo
    else:
      angulo = math.atan(i[1]/i[0])                 #Usamos math.atan para saber su angulo

    #i[0] longitud en X , i[1] longitud en Y y i[2] la velocidad
    t = (2*i[2]*math.sin(angulo))/9.8               #Se halla el tiempo de vuelo segun su velocidad
    x = i[2] * np.cos(angulo) * t                   #Se halla su posicion en X segun el tiempo de vuelo anterior t
    distancia = abs(DistanciaObjetivo - x)          #Se halla la distancia que existe entre el objetivo y la posicion final del movimiento
    fitnessList.append(distancia)                   #Se añade a la lista fitness_list la distacia anterior
    acum += distancia                               #Se va acumulando el total de las distancias
  for i in range(len(fitnessList)):                 ##Se recorre la lista fitness_list para sacar su porcentaje
    fitnessList[i] = 1-(fitnessList[i]/acum)        ##Se saca su porcentaje

  distancia_promedio = acum/len(genotipo)           #Obtenemos la distancia promedio de todos los individuos

  return (fitnessList, distancia_promedio)          #Se retornan los coeficientes fitness y la distancia promedio de los individuos
  
#Funcion para mejorar la calidad del coeficiente fitness, para ello se hizo uso de una regla de 3 simple
#con la cual se busca que la suma de todos los coeficientes de 1, siendo la mejor opcion para 
#saber la probabilidad de cada individuo
def re_fitness(total):      #Se reciben los coeficientes fitness
  if len(total) == 2:
    total = total[0]
  b = 1                               #Valor al cual queremos ajustar la suma de los coeficientes
  a = sum(total)                      #Suma del total de coeficientes
  re_int = list()                     #Lista de los nuevos coeficientes
  for i in total:                     #Para cada coeficiente
    c = i                             #Valor a ajustar
    x = (b*c)/a                       #Segun la formula de la regla de 3 simple, x es el nuevo coeficiente fitness
    re_int.append(x)                  #Se añade a la lsita
  return re_int                       #Se retorna la nueva lista de coeficientes fitness ajustados
  
  
#Funcion para saber el promedio de los coeficientes fitness
def promedio_fitness(puntaje):
  return sum(puntaje)/len(puntaje)
  
#Funcion para convertir a binario los individuos, se usa para efectuar una mutacion mas efectiva 
def conversionBinaria(individuo):

  cdef int tamanio

  bincromosoma = list()                 #Lista para los individuos de forma binaria
  for i in individuo:                   #Para cada individuo
    x = list()                          #Lista provicional
    x.append(bin(i[0])[2:])             #Se usa la funcion de conversion a binario de python, retorna un string con las dos primeras posiciones Ob
    x.append(bin(i[1])[2:])             #Se usa la funcion de conversion a binario de python, retorna un string con las dos primeras posiciones Ob
    x.append(bin(i[2])[2:])             #Se usa la funcion de conversion a binario de python, retorna un string con las dos primeras posiciones Ob
    n=0
    for j in x:                         #Para cada elemento de la lista x
      tamanio = 6 - len(j)               #Usamons un tamaño que ira variando
      ceros = list()                    #Lista para los ceros 0
      for k in range(tamanio):           #Segun el tamaño de agregan los ceros a la lista, estos estan en formato string
        ceros.append("0")               #Se añaden a la lista

      x[n] = "".join(ceros) + "".join(x[n])   #Se hace la union de todas las listas para conformar al individuo binario
      n += 1

    bincromosoma.append(x)              #Se añade a la lista definitva de individuos binarios
  return bincromosoma                   #Se retorna a toda la poblacion convertida a binario
  
#Funcion para convertir la poblacion binaria a decimal, esta funcion se debe usar luego de la mutacion.
def conversionDecimal(individuos):

  decCromosoma = list()     #Lista de individuos decimales
  for i in individuos:        #Para cada individuo
    x = list()                #Lista provicional para cada individuo
    x.append(int(i[0],2))     #Se usa la funcion de python para la conversion de binario a decimal
    x.append(int(i[1],2))     #Se usa la funcion de python para la conversion de binario a decimal
    x.append(int(i[2],2))     #Se usa la funcion de python para la conversion de binario a decimal
    decCromosoma.append(x)    #Se añade a la lista de los individuos decimales
  return decCromosoma       #Se retorna toda la poblacion en forma decimal
  
# Esta función crea la siguiente generacion de individuos a partir de la población actual
def cruce_genes_version2(poblacion, fitness2): # Funcion de cruce cuyo parametro de entrada son la población actual ("la población padre") junto con su correspondiente fitness

  siguiente_generacion = list() # Se crea una lista en donde se almacenara la siguiente generación a medida que se vaya iterando
  
  for i in range(len(poblacion)//2):  # Se crea una repetitiva de tipo for el cual iterara hasta la mitad de la población ya que en cada iteración se creara dos nuevos individuos.

    padres = np.random.choice(len(poblacion), 2, p=fitness2)  # Se escoje dos posiciones aleatorias, las cuales seran seleccionadas por el fitness de la población actual

    for i in range(2):  # Se crea una repetitiva de tipo for el cual creara dos nuevos individuos para la siguiente generación

      genesXYV = list() # Se crea una nueva lista en la cual se almacenara las caracteristicas de los individuos [X, Y, V] 

      genesXYV.append(poblacion[  padres[np.random.randint(2)]  ][0]) # Se asigna el atributo X de alguno de los dos padres 
      genesXYV.append(poblacion[  padres[np.random.randint(2)]  ][1]) # Se asigna el atributo Y de alguno de los dos padres 
      genesXYV.append(poblacion[  padres[np.random.randint(2)]  ][2]) # Se asigna el atributo V de alguno de los dos padres 
      siguiente_generacion.append(genesXYV) # El individuo hijo se agrega a la lista de la siguiente generacion

  return siguiente_generacion # La función cruce retorna la lista de la siguiente generación 
  
# Esta función tendra como objetivo alterar alguno de los atributos de los individuos de una forma aleatoria con el fin de que la población no quede "estancada" en una solución cercana o alejada de la deseada
def mutacion(poblacion, probabilidad_mutacion=0.005):  # Esta funcion de mutacion tiene como paramtros de entrada la generación resultante de la función de cruce, cuyos atributos estaran 
                                                                              # redefinidos de formato binario además de tener como otro paramtero la probabilidad de mutación, esta ultima se definio por defecto 
                                                                              # como 0.005 o 0.5%

  for i in range(len(poblacion)): # Se cra una repetitiva for que recorrera toda la población

    probabilidad_cambio = np.random.random()  # Con ayuda del modulo Numpy se crea una variable denominada 'probabilidad de cambio'

    if probabilidad_mutacion > probabilidad_cambio: # Dependiendo de la variable 'probabilidad de cambio' se determinara si el individuo que se esta recorriendo tendra un cambio en alguno de sus atributos

      individuo_mutante = poblacion[i]  # El individuo que fue escogido de manera aleatoria se guardara en una lista denominada 'individuo mutante'
      posicion_fenotipo = np.random.randint(3)  # Se selecciona de manera aleatoria el atributo a cambiar, para ello se debe tener en cuenta que 0 representa X, 1 representa Y y 2 representa V
      posicion_gen = np.random.randint(len(individuo_mutante))  # Se elije la posición del bit que se desea cambiar
      aux = list(individuo_mutante[posicion_fenotipo])  # Para modificar los atributos de tipo caracter es necesario combertir el atributo que se desea cambiar en una lista nombrada 'aux'
      
      if aux[posicion_gen] == '0':  # Si la posición binaria del atributo posee un '0' entrara en la condicional para cambiar su contenido por un '1'
        aux[posicion_gen] = '1'
      else: # Si la posición binaria del atributo posee un '1' entrara en la condicional para cambiar su contenido por un '0'
        aux[posicion_gen] = '0' 

      individuo_mutante[posicion_fenotipo] = ''.join(aux) # Una vez se haya realizado la modificación se procede nuevamente a cambiar la lista aux a cadena de caracteres
      poblacion[i] = individuo_mutante  # Se guarda la modificación realizada en el individuo derivado de la función de cruce

  return poblacion  # Retorna la población mutada de la función
  


# Esta función grafica las generaciones obtenidas de la lista_generaciones
def graficar_generaciones(lista_g= []):

  fig, axs = plt.subplots(2, 3) # Se crean las subgraficas cuyas dimensiones seran de 2 filas y 3 columnas

  c1 = 0;  c2 = -1  # Las variables c1 y c2 determinaran en que posicion sera puesta la subgrafica, siendo c1 la fila y c2 la columna

  fig.suptitle('\nGraficas De Generaciones Obtenidas Por El Usuario', fontsize=16) # Se asigna el titulo a la grafica con un tamaño de letra de 16

  fig.set_figheight(10) # Se asignan 10 de altura a la grafica
  fig.set_figwidth(15)  # Se asignan 15 de ancho a la grafica

  for i in range(len(lista_g)): # Se crea una repetitiva de tipo for que iterara hasta el tamaño de la lista

    c2 += 1 # Se modifica la posición de la columna 

    if i==3:  # Cuando la variable i tenga el valor de 3 se procedera a cambiar las posiciones del c1 y del c2 para que estas puedan estar en la segunda fila
      c1 = 1; c2 = 0

    

    for j in lista_g[i][0]:  # Repetitiva for que iterara la cantidad de individuos que haya en la población

      #print(i)

      axs[c1, c2].plot(0,0, marker="*", color="red")  # Se dibuja el punto de partida en la grafica
      axs[c1, c2].plot(DistanciaObjetivo, 0, marker="D", color="blue")# Se dibuja punto objetivo al que se desea llegar
      (x1, y1) = movimientoparabolico(j[0], j[1], j[2]) # Se obtienen las coordenadas X y Y del movimiento parabolico
      axs[c1, c2].plot(x1, y1) # Se grafica los movimientos parabolicos de la población
  
      
    axs[c1, c2].set_title('Generación N '+ str(lista_g[i][1]))
    axs[c1, c2].grid(True)
    
#lista_generaciones[1][0]
#graficar_generaciones(lista_generaciones)

# Esta función tiene como fin graficar la dispersión de los elementos y mostrar la evolución de las generaciones obtenidas
def graficar_progreso(progreso):

  print('\n')

  plt.figure(figsize=(10,6)) #  Se asignan 6 de altura y 10 de anchura a la grafica

  for i in range(len(progreso)):  # Repetitiva for que recorrera la lista_distancia

    plt.plot(i, progreso[i], marker="o")  # Graficación del promedio obtenido de la población recorrida

  # Nombramiento de los ejes y titulo de la grafica
  plt.xlabel('Numero de Generaciones')
  plt.ylabel('Progreso')
  plt.title('Progreso de las generaciones')
  
  plt.grid()
  plt.show()
  
#graficar_progreso(lista_distancia)


def ejecutar():

 global Generaciones

 #La poblacion se albergara en una lista
 cromosoma = []

 # Estructura genetica: [X, Y, Velocidad]
 for i in range(PoblacionTotal):     #Se itera segun la cantidad de individuos que el usuario ingreso

   x = np.random.randint(x0)         #Se asigna una longitud X, sera de maximo el xo que ingreso el usuario
   y = np.random.randint(y0)         #Se asigna una longitud Y, sera de maximo el yo que ingreso el usuario
   v = np.random.randint(v0)         #Se asigna una velocidad V, sera de maximo la vo que ingreso el usuario

   cromosoma.append([x, y, v])       #Cada individuo es una lista, por lo tanto la lista cromosoma es una lista de listas


 # Obteniendo posiciones a plasmar
 lista_posiciones = list(np.linspace(0, Generaciones, num=7)) # Se obtiene una lista de 7 posiciones las cuales tendran el objetivo de representar la evolución de las generaciones obtenidas por el usuario 


 for i in range(Generaciones): # Repetitiva for que iterara las generaciones dadas por el usurario

   for j in lista_posiciones:  # Repetitiva for que buscara si el numero de la generaciones corresponde a uno de los valores de la lista_posiciones

     if i == int(j): # En caso de que haya coincidencia con el contenido de 'lista_posiciones' se guardara la población actual en la lista de generaciones
       lista_generaciones.append([cromosoma, i])

   (fitnessList, distancia_promedio) = fitness(cromosoma)  # Con la función fitness se extrae la probabilidad de cruce junto con el promedio de la diferencia de la distancia del objetivo

   lista_distancia.append(distancia_promedio)  # Se agrega la distancia promedio obtenida de la función fitness en lista_distancia

   cromosoma = cruce_genes_version2(cromosoma, re_fitness(fitnessList))  # Se envia la población actual y la probabilidad de reproducción reescrita en porcentaje para obtener la siguiente generación
   cromosoma = conversionBinaria(cromosoma)  # Antes de obtener la mutación de la población es necesario convertir los atributos de los individuos (X, Y y V) a forma binaria
   cromosoma = conversionDecimal(mutacion(cromosoma))  # Para obtener a la siguiente población es necesario convertir nuevamente los atributos binarios a decimal

#graficacion_cromosoma(cromosoma)  # Se grafica el cromosoma resultante de la población obtenida por el usuario


 while distancia_promedio > 20:  # Repetitiva while que iterara hasta que el promedio de la distancia de alguna generación sea menos de 10 

   Generaciones +=1  # Por cada vez que se haga una iteración en busca de la población ideal se aumentara 1 punto al numero de generaciones
   (fitnessList, distancia_promedio) = fitness(cromosoma)# Con la función fitness se extrae la probabilidad de cruce junto con el promedio de la diferencia de la distancia del objetivo
   lista_distancia.append(distancia_promedio)  # Se agrega la distancia promedio obtenida de la función fitness en lista_distancia
   cromosoma = cruce_genes_version2(cromosoma, re_fitness(fitnessList)) # Se envia la población actual y la probabilidad de reproducción reescrita en porcentaje para obtener la siguiente generación
   cromosoma = conversionBinaria(cromosoma)  # Antes de obtener la mutación de la población es necesario convertir los atributos de los individuos (X, Y y V) a forma binaria
   cromosoma = conversionDecimal(mutacion(cromosoma)) # Para obtener a la siguiente población es necesario convertir nuevamente los atributos binarios a decimal

 #print("Se necesitaron ", Generaciones, " generaciones para tener una distancia promedio de 4")
#graficacion_cromosoma(cromosoma)

#graficar_progreso(lista_distancia)

