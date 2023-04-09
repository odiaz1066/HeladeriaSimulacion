extends Node

var modeloActual
var colaActual
var mesasActuales
var tablaTiemposActual
var llegadas
var servicios
var limite
var servidores
var servidores_activos = []
var indice_servicio = 0
var activo = false
var pasoActual = 0
var numeroClientes = 0
var velocidades = {
	"Normal" : 1,
	"Lento" : 0.5,
	"Rapido" : 1.5
}
var velocidad = "Normal"
@export var pasos = 10000

func iniciarModelo(llegadas, servicios, limite, servidores):
	self.llegadas = llegadas
	self.servicios = servicios
	self.limite = limite
	self.servidores = servidores
	
	if servidores == 1:
		if limite == 0:
			modeloActual = Modelos.ModeloUnServidorSinLimite.new(llegadas, servicios)
		else:
			modeloActual = Modelos.ModeloUnServidorConLimite.new(llegadas, servicios, limite)
	else:
		if limite == 0:
			modeloActual = Modelos.ModeloVariosServidoresSinLimite.new(llegadas, servicios, servidores)
		else:
			modeloActual = Modelos.ModeloVariosServidoresConLimite.new(llegadas, servicios, servidores, limite)

func convertMapaToGlobal(vector):
	return Vector2(vector.x * 64 + 32, vector.y * 64 + 32)

# Called when the node enters the scene tree for the first time.
func _ready():
	modeloActual = Modelos.ModeloVariosServidoresSinLimite.new(0.2, 0.4, 4) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
