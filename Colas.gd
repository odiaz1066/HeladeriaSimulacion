extends Node2D

var dist = Distribuciones.new()
var llegadas = []
var media_llegadas
var ultima_llegada = 0
var tiempo_actual = 0


func calcularLlegada():
	var probabilidad = dist.exponencial(media_llegadas, tiempo_actual - ultima_llegada)
	var dado = randf()
	return dado <= probabilidad

# Called when the node enters the scene tree for the first time.
func _ready():
	print(dist.exponencial(0.5, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
