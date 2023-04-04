extends Node2D

func calcular():
	var modelo = Modelos.ModeloVariosServidoresConLimite.new(0.5, 0.2, 4, 6)
	print(modelo.p0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boton_calcular_pressed():
	calcular()
