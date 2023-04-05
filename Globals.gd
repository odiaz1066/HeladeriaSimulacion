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
@export var pasos = 60

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

# Called when the node enters the scene tree for the first time.
func _ready():
	modeloActual = Modelos.ModeloUnServidorSinLimite.new(0.2, 0.4) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
