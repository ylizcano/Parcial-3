estadosposibles = [
                   
  [[1,1,1,2,2,2],[0,0,0,0,0,0]],  #0 Estado Inicial

  [[0,1,1,2,2,2],[1,0,0,0,0,0]],
  [[0,0,1,2,2,2],[1,1,0,0,0,0]],
  [[0,0,0,2,2,2],[1,1,1,0,0,0]],
  [[0,1,1,0,2,2],[1,0,0,2,0,0]],
  [[0,0,1,0,0,2],[1,1,0,2,2,0]],
  [[1,1,1,0,0,0],[0,0,0,2,2,2]],
  [[0,1,1,0,0,0],[1,0,0,2,2,2]],
  [[0,0,1,0,0,0],[1,1,0,2,2,2]],

  [[0,0,0,0,0,0],[1,1,1,2,2,2]]  # Estado Final
  #['0I', '3D', '2I', '8D', '5I', '9D']

]

class Cabernicola():

 def ejecutar(self):
  ejecutar_Cavernicola_py()
  

def cantidadCyM(listas, indice):
  
  lista = listas[indice]
  c = 0     # Cantidad de canibales  
  m = 0     # Cantidad de misioneros

  for i in lista:
    if i == 1:
      c += 1
    elif i == 2:
      m +=1
  return (c, m)  

#### función para encontrar el camino entre dos nodos de un grafo (shortest path)
def bfs_shortestPath(grafo, inicio, objetivo):
  # Mantener la pista de todos los nodos visitados
  visitados = []
  # Mantener la pista de los caminos a ser revisados 
  cola = [[inicio]]
  # regreso el camino sí el "inicio" es el "objetivo"
  if inicio == objetivo:
    return "El inicio es el objetivo (Búsqueda fácil!!!!)"
  # Estar dentro del bucle hasta que todos los caminos posibles sean revisados
  while cola:
    # Sacar el primer camino de la cola
    camino = cola.pop(0)
    node = camino[-1]
    if node not in visitados:
      vecinos = grafo[node]
      #Iterar para agregar vecinos del nodo a la cola
      for vecino in vecinos:
        new_camino = list(camino)
        new_camino.append(vecino)
        # Agregar vecinos del nodo a la cola
        cola.append(new_camino)
        # Revisar si el vecino es el objetivo
        if vecino == objetivo:
          return new_camino
      
      # Se marcan los nodos visitados
      visitados.append(node)

    ### En caso de que no haya camino corto entre dos nodos (2 Nodos)
    return "no hay camino"


def backtrace(parent, start, end):
  #se crea una lista path para guardar 
  path = [end]
  #se va verifinado su nodo padre, se traza la ruta desde el nodo objetivo
  while path[-1] != start:
    #se verifica el nodo padre de los nodos 
    path.append(parent[path[-1]])
    #se arregla el orden de la lista, para ver la ruta desde el principio
    path.reverse()
  return path

def bfs(graph, start, end):
  parent = {}
  # Mantener la pista de los caminos a ser revisados
  queue = []
  # se iniciliza la cola
  queue.append(start)
  while queue:
    #se saca de la cola el primer nodo, para evaluarlo
    node = queue.pop(0)
    #print(node)
    #se comprueba que el nodo que se acabo de sacar de la cola sea igual al objetivo(fin)
    if node == end:
      #se usa el metodo backtrace para trazar el camino
      return backtrace(parent, start, end)
    #se evaluan todas las llaves del diccionario(grafo)
    for adjacent in graph.get(node):
      #se valida que el nodo aun no se encuentre en la cola
      if node not in queue:
        #se asignan valores al diccionario parent
        parent[adjacent] = node   # se guarda su pariente
        queue.append(adjacent)    # se añaden los nuevos caminos
        
def ejecutar_Cavernicola_py():

	grafo = {}

	# 0 el lado Izquierdo / 1 el lado Derecho
	lado = 0 

	for i in range(len(estadosposibles)):

	  lista = []

	  estadopresente = cantidadCyM(estadosposibles[i], lado)

	  # 1 Canibal
	  if estadopresente[0] >= 1:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[0] == (estadopresente[0]-1) and estadofuturo[1] == estadopresente[1]:
	     lista.append(n)
	    n += 1  

	  # 2 Canibales
	  if estadopresente[0] >= 2:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[0] == (estadopresente[0]-2) and estadofuturo[1] == estadopresente[1]:
	     lista.append(n)
	    n += 1 

	  # 3 Canibales 
	  if estadopresente[0] == 3:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[0] == 0 and estadofuturo[1] == estadopresente[1]:
	     lista.append(n)
	    n += 1  

	  # 1 Misionero
	  if estadopresente[1] >= 1:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[1] == (estadopresente[1]-1) and estadofuturo[0] == estadopresente[0]:
	     lista.append(n)
	    n += 1 

	  # 2 Misioneros
	  if estadopresente[1] >= 2:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[1] == (estadopresente[1]-2) and estadofuturo[0] == estadopresente[0]:
	     lista.append(n)
	    n += 1 

	  # 3 Misioneros
	  if estadopresente[1] >= 3:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[1] == (estadopresente[1]-3) and estadofuturo[0] == estadopresente[0]:
	     lista.append(n)
	    n += 1 
	  
	  # 1 Misionero  y 1 Canibal
	  if estadopresente[1] >= 1 and estadopresente[0] >= 1:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[1] == (estadopresente[1]-1) and estadofuturo[0] == (estadopresente[0]-1):
	     lista.append(n)
	    n += 1 

	  # 2 Misionero  y 1 Canibal
	  if estadopresente[1] >= 2 and estadopresente[0] >= 1:
	   n = 0
	   for j in estadosposibles:
	    estadofuturo = cantidadCyM(j, lado)
	    if estadofuturo[1] == (estadopresente[1]-2) and estadofuturo[0] == (estadopresente[0]-1):
	     lista.append(n)
	    n += 1 

	  grafo[i] = lista 

	  if lado == 0:
	    lado = 1
	  else:
	    lado = 0
	    
	    
	grafo2 = {}

	# 0 el lado Izquierdo / 1 el lado Derecho
	lado = 0 
	ladopalabra = ''

	for j in range(2):

	  if lado == 0:
	      lado = 1
	  else:
	    lado = 0

	  for i in range(len(estadosposibles)):

	    lista = []
	    #se evaluan cuantos canibales y misioneros hay en un lado
	    estadopresente = cantidadCyM(estadosposibles[i], lado) 
	    # se evalua cuando hay un canibal del lado derecho
	    if estadopresente[0] >= 1:
	      n = 0
	      #para iterar entre todos los estados posibles
	      for j in estadosposibles:
	      	#se nombra como estadofuturo la tupla que retorna la cantidad de canibales y misioneros segun el lado
	      	estadofuturo = cantidadCyM(j, lado)
	      	#se evalua si el estadopresente corresponde a alguno de los distintos estadosfuturos, en este caso solo importan los canibales,
	      	#es decir, el estadofuturo[0].
	      	if estadofuturo[0] == (estadopresente[0]-1) and estadofuturo[1] == estadopresente[1]:
	      	#se indica de que lado se ha encontrado la validacion anterior
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1  

	    # 2 Canibales
	    if estadopresente[0] >= 2:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[0] == (estadopresente[0]-2) and estadofuturo[1] == estadopresente[1]:
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 

	    # 3 Canibales 
	    if estadopresente[0] == 3 and estadopresente[0] <= estadopresente[1]:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[0] == 0 and estadofuturo[1] == estadopresente[1]:
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1  

	    # 1 Misionero
	    if estadopresente[1] >= 1:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[1] == (estadopresente[1]-1) and estadofuturo[0] == estadopresente[0]:
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 

	    # 2 Misioneros
	    if estadopresente[1] >= 2:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[1] == (estadopresente[1]-2) and estadofuturo[0] == estadopresente[0]:
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 

	    # 3 Misioneros
	    if estadopresente[1] >= 3:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[1] == (estadopresente[1]-3) and estadofuturo[0] == estadopresente[0]:
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 
	    
	    # 1 Misionero  y 1 Canibal
	    if estadopresente[1] >= 1:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
		#se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[1] == (estadopresente[1]-1) and estadofuturo[0] == (estadopresente[0]-1):
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 

	    # 2 Misionero  y 1 Canibal
	    if estadopresente[1] >= 2 and estadopresente[0] >= 1:
	      n = 0
	      for j in estadosposibles:
	      	estadofuturo = cantidadCyM(j, lado)
	      #se evalua que la cantidad de canibales no supere la cantidad de misioneros
	      	if estadofuturo[1] == (estadopresente[1]-2) and estadofuturo[0] == (estadopresente[0]-1):
	      	 if lado == 0:
	      	  lista.append(str(n)+'D')
	      	 else:
	      	  lista.append(str(n)+'I')
	      	n += 1 

	    if lado == 0:
	      grafo2[str(i)+'I'] = lista 
	    else:
	      grafo2[str(i)+'D'] = lista

        
	#se verifica la respuesta
	ans = bfs(grafo2,'0I','9D')
	#se imprime hasta la posicion 5, para no tener encuenta los demas hijos
	#print(ans[:6])
	#este resultado indica los indices de los estados que representan una accion en el juego y la ubicacion de la barca  
	

