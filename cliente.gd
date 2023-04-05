extends CharacterBody2D


var velocidad = 200.0
var posicion_objetivo = Vector2(12 * 64 + 32, 7 * 64 + 32)
@onready var navigation_agent = $NavigationAgent2D

func _ready():
	call_deferred("agent_setup")

func agent_setup():
	await get_tree().physics_frame
	
	#definirObjetivo(posicion_objetivo)
	#moverAMesa(0)
	
func definirObjetivo(objetivo):
	navigation_agent.target_position = objetivo

func moverAMesa(n):
	posicion_objetivo = Globals.servidores_activos[n].silla_posicion * 64
	definirObjetivo(Vector2(posicion_objetivo.x + 16 + (8 * (n)), posicion_objetivo.y + 16))

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var posicion_agente = global_transform.origin
	var siguiente_posicion = navigation_agent.get_next_path_position()
	
	var nueva_velocidad = siguiente_posicion - posicion_agente
	nueva_velocidad = nueva_velocidad.normalized()
	nueva_velocidad *= velocidad
	
	set_velocity(nueva_velocidad)

	move_and_slide()
