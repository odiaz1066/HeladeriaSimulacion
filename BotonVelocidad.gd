extends OptionButton

var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for velocidad in Globals.velocidades:
		items.push_back(velocidad)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_selected(index):
	Globals.velocidad = items[index]
