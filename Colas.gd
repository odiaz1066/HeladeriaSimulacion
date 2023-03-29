extends Node2D

var dist = Distribuciones.new()
var llegadas = []
var media_llegadas = 0.2
var ultima_llegada = 0
var tiempo_actual = 0
var cola

class Cola:
	var clientes
	var limite
	func _init(limite=0):
		self.clientes = []
		self.limite = limite
		
	func entra(cliente):
		if (self.limite != 0) and (len(self.clientes) >= self.limite):
			return false
		else:
			self.clientes.push_back(cliente)
			return true
		
	func sale():
		return self.clientes.pop_front()

class TablaTiempos:
	var tiempos
	var parent
	
	func _init(parent):
		self.tiempos = []
		self.parent = parent
	
	func llenarTablaLlegadas(pasos = 60):
		self.tiempos = []
		var ultima_llegada_sim = 0
		for n in range(0, pasos):
			var nueva_llegada = parent.calcularLlegada(n, ultima_llegada_sim)
			if (nueva_llegada):
				self.tiempos.push_back(n)
				ultima_llegada_sim = n

func calcularLlegada(tiempo_actual=tiempo_actual, ultima_llegada=ultima_llegada):
	var probabilidad = dist.exponencial(media_llegadas, tiempo_actual - ultima_llegada)
	var dado = randf()
	return dado <= probabilidad

# Called when the node enters the scene tree for the first time.
func _ready():
	cola = Cola.new()
	ultima_llegada = Time.get_ticks_msec() / 1000
	var llegadas = TablaTiempos.new(self)
	llegadas.llenarTablaLlegadas()
	print(llegadas.tiempos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#tiempo_actual = Time.get_ticks_msec() / 1000
	#if (tiempo_actual - ultima_llegada) >= 1:
	#	var nuevo_cliente = calcularLlegada()
	#	if nuevo_cliente:
	#		cola.entra(3)
	#		ultima_llegada = Time.get_ticks_msec() / 1000
	#	print(cola.clientes)
	
