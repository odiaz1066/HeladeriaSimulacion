extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pn_calcular_button_pressed():
	var child = self.get_child(0)
	self.remove_child(child)
	var n = int($%PnCalcularInput.text)
	Globals.PnInputValue = n
	var output = LineEdit.new()
	output.text = str(Globals.modeloActual.calcularPn(n))
	self.add_child(output)
