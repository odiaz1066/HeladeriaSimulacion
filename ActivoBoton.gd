extends CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	if Globals.colaActual == null:
		OS.alert("Presione el boton 'Calcular' primero")
		set_pressed_no_signal(false)
		return
	Globals.activo = button_pressed
