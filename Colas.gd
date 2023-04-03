extends Node2D

var dist = Distribuciones.new()
var llegadas = []
var media_llegadas = 0.2
var media_servicio = 0.2
var ultima_llegada = 0
var tiempo_actual = 0
var timestep = 1000
var mesas = 1
var cola

class Modelo:
	var lambda
	var mu
	var num_servidores
	var rho
	var p0
	var lq
	var ls
	var wq
	var ws

class ModeloUnServidorSinLimite extends Modelo:
	func _init(lambda, mu):
		self.lambda = lambda
		self.mu = mu
		self.rho = self.lambda / self.mu
		self.p0 = 1 - self.rho
		self.ls = self.rho / self.p0
		self.lq = self.ls - self.rho
		self.ws = self.ls / self.lambda
		self.wq = self.lq / self.lambda

class ModeloVariosServidoresSinLimite extends Modelo:
	func _init(lambda, mu, num_servidores):
		self.lambda = lambda
		self.mu = mu
		self.num_servidores = num_servidores
		self.rho = self.lambda / (self.num_servidores * self.mu)
		self.u = self.rho / self.num_servidores
		self.lq = (self.u ** (self.num_servidores + 1) * self.p0 * self.mu) / (self.num_servidores * (1 - self.u))
		self.ls = self.lq + self.lambda / self.mu
		self.wq = self.lq / self.lambda
		self.ws = self.ls / self.lambda
		
	func calcularP0():
		var math = Distribuciones.new()
		var a = 0.0
		for i in range(0, self.num_servidores):
			a += (self.rho ** i) / math.factorial(i)
		var b = (self.rho ** self.num_servidores) / (math.factorial(self.num_servidores) * (1 - (self.mu / self.lambda)))
		self.p0 = 1 / (a + b)
		return self.p0

class Cola:
	var clientes
	var limite
	
	func _init(limite=0):
		self.clientes = []
		self.limite = limite
	
	func length():
		return len(self.clientes)
		
	func entra(cliente):
		if (self.limite != 0) and (len(self.clientes) >= self.limite):
			return false
		else:
			self.clientes.push_back(cliente)
			return true
		
	func sale():
		return self.clientes.pop_front()

class TablaTiempos:
	var llegadas
	var servicios
	var parent
	
	func _init(parent):
		self.llegadas = []
		self.servicios = []
		self.parent = parent
	
	func llenarTablaLlegadas(pasos = 60):
		self.llegadas = []
		var ultima_llegada_sim = 0
		for n in range(0, pasos):
			var nueva_llegada = parent.calcularLlegada(n, ultima_llegada_sim)
			if (nueva_llegada):
				self.llegadas.push_back(n)
				ultima_llegada_sim = n
	
	func llenarTablaServicios(pasos = 60):
		if (len(self.llegadas) == 0):
			self.llenarTablaLlegadas(pasos)
		self.servicios = []
		var servidores = {}
		for mesa in range(1, parent.mesas + 1):
			servidores[mesa] = null
		var cola_sim = Cola.new()
		var proxima_llegada = 0
		for n in range(0, pasos):
			for servidor in servidores:
				if servidores[servidor] != null:
					servidores[servidor] -= 1
					if servidores[servidor] <= 0:
						servidores[servidor] = null
						#self.servicios.push_back(n)
				else:
					if cola_sim.length() != 0:
						servidores[servidor] = parent.calcularServicio(pasos - n)
						self.servicios.push_back([n, n + servidores[servidor]])
						cola_sim.sale()
			if len(self.llegadas) <= proxima_llegada:
				continue
			if self.llegadas[proxima_llegada] == n:
				cola_sim.entra(n)
				proxima_llegada += 1
						

func calcularLlegada(tiempo_actual=tiempo_actual, ultima_llegada=ultima_llegada):
	var probabilidad = dist.exponencial(media_llegadas, tiempo_actual - ultima_llegada)
	var dado = randf()
	return dado <= probabilidad

func calcularServicio(pasos_restantes):
	var probabilidad
	var dado
	var duracionServicio = 0
	while true:
		probabilidad = dist.exponencial(media_servicio, duracionServicio)
		dado = randf()
		if dado <= probabilidad:
			return duracionServicio
		duracionServicio += 1

func prepararDistribucion(array):
	var resultado = []
	var ultimo_n = 0
	for n in array:
		resultado.push_back(n - ultimo_n)
		ultimo_n = n
	return resultado

# Called when the node enters the scene tree for the first time.
func _ready():
	cola = Cola.new()
	ultima_llegada = Time.get_ticks_msec() / timestep
	var tiempos = TablaTiempos.new(self)
	tiempos.llenarTablaServicios()
	#print(tiempos.llegadas)
	#print(tiempos.servicios)
	#print(prepararDistribucion(tiempos.llegadas))
	var modelo = ModeloUnServidorSinLimite.new(0.2, 0.2)
	print(modelo.rho)

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
	
