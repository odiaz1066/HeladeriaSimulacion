extends CharacterBody2D


var velocidad = 300.0
var posicion_objetivo = Vector2(12 * 64 + 32, 7 * 64 + 32)
var posicion_inicial : Vector2
var tiempo_salida
var saliendo = false
var es_servidor = false
var numero = 1
var activo = false
var sprite
var delta_acumulado = 0
var sirviendo = false
@onready var navigation_agent = $NavigationAgent2D

var posicionEnCola = 0
var puntosDeCola = [
	Vector2(3, 6),
	Vector2(3, 7),
	Vector2(4, 7),
	Vector2(5, 7),
	Vector2(6, 7),
	Vector2(7, 7),
	Vector2(8, 7),
]

func _ready():
	if !es_servidor:
		sprite = rollSprite()
		$ClienteSprite.animation = sprite
		var dado = randf()
		if dado >= 0.66:
			var child = $ClienteSprite.duplicate()
			child.scale = Vector2(0.5, 0.5)
			child.position = Vector2(-32, 32)
			child.animation = rollSprite()
			add_child(child)
	else:
		sprite = "servidor"
		
	call_deferred("agent_setup")

func agent_setup():
	await get_tree().physics_frame
	
	#definirObjetivo(posicion_objetivo)
	#moverAMesa(0)
	
func definirObjetivo(objetivo):
	navigation_agent.target_position = objetivo
	$ClienteSprite.animation = sprite

func moverAMesa(n):
	posicion_objetivo = Globals.convertMapaToGlobal(Globals.servidores_activos[int(n)].silla_posicion)
	definirObjetivo(Vector2(posicion_objetivo.x, posicion_objetivo.y - 16))
	$ClienteSprite.animation = sprite + "_act"

func regresar():
	definirObjetivo(posicion_inicial)
	
func avanzarEnCola(cambio = 0):
	posicionEnCola -= cambio
	if posicionEnCola < len(puntosDeCola):
		definirObjetivo(Globals.convertMapaToGlobal(puntosDeCola[posicionEnCola]))
	else:
		var base = puntosDeCola[len(puntosDeCola) - 1]
		var ubicacion = Vector2(base.x, base.y + posicionEnCola + 1 - len(puntosDeCola))
		definirObjetivo(Globals.convertMapaToGlobal(ubicacion))

func rollSprite():
	var dado = randf()
	if dado > 0.5:
		return "mujer"
	else:
		return "hombre"
		
func moverServidor():
	var direccion
	if sirviendo:
		direccion = -1
	else:
		direccion = 1
	definirObjetivo(Vector2(posicion_inicial.x, posicion_inicial.y + (32 * direccion)))
	sirviendo = !sirviendo
	$ClienteSprite.animation = sprite + "_act"
	
func _physics_process(delta):
	if es_servidor:
		if activo:
			delta_acumulado += delta
			if delta_acumulado > 0.5:
				delta_acumulado = 0
				moverServidor()
		else:
			look_at(Vector2(posicion_inicial.x, posicion_inicial.y + 64))
	if navigation_agent.is_navigation_finished():
		if saliendo:
			get_parent().remove_child(self)
		return
	var posicion_agente = global_transform.origin
	var siguiente_posicion = navigation_agent.get_next_path_position()
	
	var nueva_velocidad = siguiente_posicion - posicion_agente
	nueva_velocidad = nueva_velocidad.normalized()
	nueva_velocidad *= velocidad * Globals.velocidades[Globals.velocidad]
	
	set_velocity(nueva_velocidad)
	
	look_at(siguiente_posicion)
	
	move_and_slide()
