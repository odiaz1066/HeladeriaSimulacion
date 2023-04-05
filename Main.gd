extends Node2D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boton_calcular_pressed():
	var llegadas = float($%LlegadasInput.text)
	var servicios = float($%ServiciosInput.text)
	var limite = float($%LimiteInput.text)
	var servidores = float($%ServidoresInput.text)
	
	Globals.iniciarModelo(llegadas, servicios, limite, servidores)
	
	calcularPropiedades()
