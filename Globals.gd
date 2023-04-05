extends Node

var PnInputValue = 0
var modeloActual
var colaActual
var llegadas
var servicios
var limite
var servidores

func iniciarModelo(llegadas, servicios, limite, servidores):
	llegadas = llegadas
	servicios = servicios
	limite = limite
	servidores = servidores
	
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
