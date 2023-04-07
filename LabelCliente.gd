extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(get_parent().numero)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
	var fixedPosition = get_parent().global_position
	global_position = Vector2(fixedPosition.x - 8, fixedPosition.y - 48)
