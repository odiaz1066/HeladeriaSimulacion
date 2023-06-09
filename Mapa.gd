extends TileMap

var ServidorNode = preload("res://servidor.tscn")
var servidores = []
var min_x = 3
var min_y = 2
var max_x = 15
var max_y = 9
var fila_mesas = 4
var fila_sillas = 5
var fila_servidores = 3
var entrada = Vector2(max_x / 2 + 1, max_y + 1.5)
var salida = Vector2(entrada.x + 1, entrada.y)
@onready var map_size = get_used_rect().size 
@onready var heladeria_size = map_size - Vector2i(min_x + (map_size.x - max_x), min_y + (map_size.y - max_y))

class Servidor:
	var mesa_posicion = Vector2(0, 0)
	var persona
	var silla_posicion = Vector2(0, 0)
	
	func _init(posicion, fila_sillas):
		mesa_posicion = posicion
		silla_posicion = Vector2i(mesa_posicion.x, fila_sillas)
		

func cargarServidores(n):
	limpiarServidores()
	var posiciones = []
	for i in range(1, n + 1):
		posiciones.push_back(Vector2i(min_x + (heladeria_size.x / (n + 1)) * i, fila_mesas))#min_y + ((heladeria_size.y - 1) / (n + 1)) * i))
	servidores = {}
	var indice_servidor = 0
	for posicion in posiciones:
		var servidor = Servidor.new(posicion, fila_sillas)
		set_cell(2, servidor.mesa_posicion, 0, Vector2(24, 18))
		set_cell(2, servidor.silla_posicion, 0, Vector2(16, 19))
		var persona = ServidorNode.instantiate()
		persona.position = Vector2i(servidor.mesa_posicion.x * 64 + 32, fila_servidores * 64 + 32)
		persona.posicion_inicial = persona.position
		persona.es_servidor = true
		add_child(persona)
		servidor.persona = persona
		servidores[indice_servidor] = servidor
		indice_servidor += 1
	Globals.servidores_activos = servidores
		
func limpiarServidores():
	for i in range(min_x, min_x + heladeria_size.x + 1):
		set_cell(2, Vector2i(i, fila_mesas))
		set_cell(2, Vector2i(i, fila_sillas))
		set_cell(3, Vector2i(i, fila_mesas))
		for child in get_children():
			remove_child(child)
			
func mostrarPlato(mesa, mostrar=true):
	var tile
	if mostrar:
		tile = Vector2(24, 7)
	else:
		tile = Vector2(-1, -1)
	set_cell(3, Globals.servidores_activos[mesa].mesa_posicion, 0, tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_cell(2, Vector2(3, 0), 0, Vector2(24, 18))
	cargarServidores(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
