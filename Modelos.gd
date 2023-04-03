extends Node

class_name Modelos

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
	var math = Distribuciones.new()

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
	
	func calcularPn(n):
		return (1 - self.rho) * (self.rho ** n)
		
class ModeloUnServidorConLimite extends Modelo:
	func _init(lambda, mu, limit=0):
		self.lambda = lambda
		self.mu = mu
		self.rho = lambda / mu
		self.limit = limit
		self.p0 = self.calcularP0()
		self.ls = self.calcularLs()
		self.lq = self.calcularLq()
		self.ws = self.calcularWs()
		self.wq = self.calcularWq()
		
	func calcularP0():
		if self.rho == 1:
			return 1 / (self.limit + 1)
		else:
			return (1 - self.rho) / (1 - (self.rho ** (self.limit + 1)))
	
	func calcularPn(n):
		return self.p0 * (self.rho ** n)
	
	func calcularLs():
		if self.rho == 1:
			return self.limit / 2
		else:
			var a = self.rho * (1 - ((self.limit + 1) * (self.rho ** self.limit)) + (self.limit * (self.rho ** (self.limit + 1))))
			var b = (1 - self.rho) * (1 - (self.rho ** (self.limit + 1)))
			return a / b
	
	func calcularLq():
		return self.ls - (self.lambda * (1 - self.calcularPn(self.limit)) / self.mu)
		
	func calcularWq():
		return self.lq / (self.lambda * (1 - self.calcularPn(self.limit)))
		
	func calcularWs():
		return self.wq + (self.mu ** -1)
		
	func calcularPnIntervalo(inicio, fin):
		var Pn = 0
		var p = 0
		for i in range(inicio, fin + 1):
			p = self.rho ** i
			if p < 0.0001:
				break
			Pn += p
		return self.p0 * Pn

class ModeloVariosServidoresSinLimite extends Modelo:
	var p
	
	func _init(lambda, mu, num_servidores):
		self.lambda = lambda
		self.mu = mu
		self.num_servidores = num_servidores
		self.rho = self.lambda / (self.num_servidores * self.mu)
		self.p = self.rho * self.num_servidores
		self.calcularP0()
		self.lq = ((self.p ** (self.num_servidores + 1)) * self.p0) / (math.factorial(self.num_servidores - 1) * ((self.num_servidores - self.p) ** 2))
		self.ls = self.lq + self.lambda / self.mu
		self.wq = self.lq / self.lambda
		self.ws = self.ls / self.lambda
		
	func calcularP0():
		var math = Distribuciones.new()
		var a = 0.0
		for i in range(0, self.num_servidores):
			a += (self.p ** i) / math.factorial(i)
		var b = (self.p ** self.num_servidores) / (math.factorial(self.num_servidores) * (1 - self.p / self.num_servidores))
		self.p0 = 1 / (a + b)
		return self.p0
		
class ModeloVariosServidoresConLimite extends Modelo:
	func _init(lambda, mu, num_servidores, limite=null):
		self.lambda = lambda
		self.mu = mu
		self.num_servidores = num_servidores
		self.n_serv = num_servidores
		self.limite = limite
		self.rho = self.lambda / self.mu
		self.servidores_menos_p2 = (self.num_servidores - self.rho) ** 2
		if self.limite != null:
			self.z = self.rho / self.n_serve
			self.j = self.limite - self.n_serve + 1
			self.r = self.j - 1
			self.p0 = self.calcularP0()
	
	func calcularP0():
		var suma = 0
		var term_b = 0
		
		for i in range(self.n_serve):
			suma += (self.rho ** i) / math.factorial(i)
		
		if self.z != 1:
			term_b = (self.rho ** self.n_serve) * (1 - (self.z ** self.j)) / (math.factorial(self.n_serve) * (1 - self.z))
		else:
			term_b = (self.rho ** self.n_serve) / math.factorial(self.n_serve) * self.j

		return (suma + term_b) ** -1
		
	func calcularPn(n):
		var term_a = (self.rho ** self.limite) / (math.factorial(self.n_serve) * (self.n_serve ** self.r))
		return term_a * self.p0
		
	func calcularLq():
		if self.z != 1:
			var term_a = self.p0 * ((self.rho ** (self.n_serve + 1)) / (math.factorial(self.n_serve - 1) * self.servidores_menos_p2))
			var term_b = 1 - (self.z ** self.r) - (self.r * (self.z ** self.r) * (1 - self.z))
			var result = term_a * term_b
			return result
		else:
			return self.p0 * ((self.rho ** self.n_serve) * self.r * self.j / (2 * math.factorial(self.n_serve)))
	
	func calcularLs():
		return self.lq + (self.lambdaEffective() / self.mu)
	
	func calcularPnIntervalo(inicio, fin):
		var Pn = 0
		var p = 0
		for i in range(inicio, fin + 1):
			p = 0
			if i > self.n_serve:
				p = (self.rho ** i) / ((self.n_serve ** (i - self.n_serve)) * math.factorial(i))
			else:
				p = (self.rho ** i) / math.factorial(i)
			if p < 0.0001:
				break
			Pn += p
		return self.p0 * Pn
	
	func lambdaEffective():
		return self.lambda * (1 - self.calcularPn(self.limite))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
