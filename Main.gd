extends Node2D

class_name Main

var Cliente = preload("res://cliente.tscn")
var delta_acumulado = 0
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
	if (Globals.limite == 0) or (Globals.colaActual.length() < Globals.limite):
		if paso in Globals.tablaTiemposActual.llegadas:
			llegaCliente()
	for mesa in Globals.mesasActuales:
		if Globals.mesasActuales[mesa] == null:
			continue
		if Globals.mesasActuales[mesa].tiempo_salida == paso:
			saleCliente(mesa)
	if Globals.indice_servicio < len(Globals.tablaTiemposActual.servicios):
		if Globals.tablaTiemposActual.servicios[Globals.indice_servicio][0] < paso:
			var sincronizar = true
			while sincronizar:
				if Globals.tablaTiemposActual.servicios[Globals.indice_servicio][0] < paso:
					Globals.indice_servicio += 1
				else:
					sincronizar = false
		if Globals.tablaTiemposActual.servicios[Globals.indice_servicio][0] == paso:
			servirCliente(Globals.tablaTiemposActual.servicios[Globals.indice_servicio])
			Globals.indice_servicio += 1
	moverCola()
	moverServidores()

func iniciarSimulacion():
	var pasos = Globals.pasos
	Globals.indice_servicio = 0
	Globals.colaActual = Colas.Cola.new()
	Globals.mesasActuales = {}
	for i in Globals.servidores:
		Globals.mesasActuales[i] = null
	Globals.tablaTiemposActual = Colas.TablaTiempos.new(Colas.new())
	Globals.tablaTiemposActual.llenarTablaServicios(pasos)
	Globals.pasoActual = 0
	Globals.numeroClientes = 0
	Globals.activo = true

func llegaCliente():
	var cliente = Cliente.instantiate()
	cliente.position = Globals.convertMapaToGlobal(Mapa.entrada)
	cliente.posicion_inicial = cliente.position
	Globals.numeroClientes += 1
	cliente.numero = Globals.numeroClientes
	Mapa.add_child(cliente)
	Globals.colaActual.entra(cliente)
	#cliente.definirObjetivo(Globals.convertMapaToGlobal(Vector2(Mapa.entrada.x, Mapa.entrada.y + 2)))

func servirCliente(tiempos):
	for mesa in Globals.mesasActuales:
		if Globals.mesasActuales[mesa] == null:
			var cliente = Globals.colaActual.sale()
			if cliente == null:
				return
			cliente.tiempo_salida = tiempos[1]
			Globals.mesasActuales[mesa] = cliente
			Globals.servidores_activos[mesa].persona.activo = true
			cliente.moverAMesa(mesa)
			cliente.activo = true
			Mapa.mostrarPlato(mesa, true)
			break

func saleCliente(mesa):
	var cliente = Globals.mesasActuales[mesa]
	Globals.mesasActuales[mesa] = null
	#cliente.regresar()
	cliente.definirObjetivo(Globals.convertMapaToGlobal(Mapa.salida))
	cliente.saliendo = true
	cliente.activo = false
	Globals.servidores_activos[mesa].persona.activo = false
	Globals.servidores_activos[mesa].persona.regresar()
	Mapa.mostrarPlato(mesa, false)
	
func moverCola():
	var posicion = 0
	for cliente in Globals.colaActual.clientes:
		cliente.posicionEnCola = posicion
		cliente.avanzarEnCola()
		posicion += 1

func moverServidores():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Globals.activo:
		if Globals.pasoActual < Globals.pasos:
			delta_acumulado += delta
			var siguiente = 1 / Globals.velocidades[Globals.velocidad]
			if siguiente < delta_acumulado:
				pasoSimulacion(Globals.pasoActual)
				Globals.pasoActual += 1
				delta_acumulado = 0
		else:
			Globals.activo = false


func _on_boton_calcular_pressed():
	var llegadas = float($%LlegadasInput.text)
	var servicios = float($%ServiciosInput.text)
	var limite = int($%LimiteInput.text)
	var servidores = int($%ServidoresInput.text)
	
	var inputs = {"llegadas": llegadas, "servicios": servicios, "limite": limite, "servidores": servidores}
	for input in inputs:
		if input == "llegadas" or input == "servicios" or input == "servidores":
			if inputs[input] == 0:
				OS.alert("Introduzca un valor positivo de %s" % input)
				return 
		if inputs[input] < 0:
			OS.alert("%s no puede ser un numero negativo" % input)
			return
			
	Globals.llegadas = llegadas
	Globals.servicios = servicios
	Globals.limite = limite
	Globals.servidores = servidores
	
	Globals.iniciarModelo(Globals.llegadas, Globals.servicios, Globals.limite, Globals.servidores)
	
	calcularPropiedades()
	
	$%Mapa.cargarServidores(Globals.servidores)
	
	iniciarSimulacion()
