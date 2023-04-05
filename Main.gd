extends Node2D

class_name Main

var Cliente = preload("res://cliente.tscn")
@onready var Mapa = $%Mapa

func calcularPropiedades():
	var modeloActual = Globals.modeloActual
	$%LambdaOutput.text = str(modeloActual.lambda)
	$%MuOutput.text = str(modeloActual.mu)
	$%RhoOutput.text = str(modeloActual.rho)
	$%P0Output.text = str(modeloActual.p0)
	$%LqOutput.text = str(modeloActual.lq)
	$%LsOutput.text = str(modeloActual.ls)
	$%WqOutput.text = str(modeloActual.wq)
	$%WsOutput.text = str(modeloActual.ws)

func pasoSimulacion(paso):
	if paso in Globals.tablaTiemposActual.llegadas:
		llegaCliente()
	for mesa in Globals.mesasActuales:
		if mesa.salida == paso:
			saleCliente(mesa.cliente)
	if Globals.tablaTiemposActual.servicios[Globals.indice_servicio][0] == paso:
		servirCliente(Globals.tablaTiemposActual.servicios[Globals.indice_servicio])
	moverCola()

func iniciarSimulacion():
	var pasos = Globals.pasos
	Globals.indice_servicio = 0
	Globals.colaActual = Colas.Cola.new()
	Globals.mesasActuales = []
	Globals.tablaTiemposActual = Colas.TablaTiempos.new(Colas.new())
	Globals.tablaTiemposActual.llenarTablaServicios(pasos)
	Globals.activo = true
	for paso in range(0, Globals.pasos):
		pasoSimulacion(paso)

func llegaCliente():
	var cliente = Cliente.instantiate()
	var entrada = Mapa.entrada * 64
	cliente.position = Vector2(entrada.x + 32, entrada.y + 32)
	Mapa.add_child(cliente)

func servirCliente(tiempos):
	pass

func saleCliente(cliente):
	pass
	
func moverCola():
	pass

func probarSimulacion():
	var cliente = Cliente.instantiate()
	cliente.position = Vector2i(8 * 64 + 32, 7 * 64 + 32)
	$%Mapa.add_child(cliente)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Globals.activo:
		pass


func _on_boton_calcular_pressed():
	var llegadas = float($%LlegadasInput.text)
	var servicios = float($%ServiciosInput.text)
	var limite = float($%LimiteInput.text)
	var servidores = float($%ServidoresInput.text)
	
	Globals.iniciarModelo(llegadas, servicios, limite, servidores)
	
	calcularPropiedades()
	
	$%Mapa.cargarServidores(servidores)
	
	iniciarSimulacion()
