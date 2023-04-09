extends TabContainer

var cantidad_barras = 21
var rango = [0, 20]
var posicion_inicial = Vector2(25, 45)

func dibujaGrafico(container, data):
	for n in container.get_children():
		container.remove_child(n)
	var Barra = ColorRect.new()
	Barra.size = Vector2(5, 40)
	Barra.position = posicion_inicial
	for n in range(rango[0], rango[1] + 1):
		var new_barra = Barra.duplicate()
		new_barra.position += Vector2(n * 10, 0)
		var label = Label.new()
		label.text = str(n)
		new_barra.add_child(label)
		container.add_child(new_barra)
		
	var x = data[0].keys()
	var y = data[0].values()
	var max_y = data[1]
	var index = 0
	for barra in container.get_children():
		barra.size.y = (y[index] / float(max_y)) * 80
		barra.size.x = 5
		barra.position.y += 40 - barra.size.y
		var label = barra.get_child(0)
		label.position.y += barra.size.y
		index += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_boton_calcular_pressed():
	var data = Globals.tablaTiemposActual.llegadas
	data = Colas.new().prepararDistribucion(data)
	dibujaGrafico($Llegadas_Seg, data)
