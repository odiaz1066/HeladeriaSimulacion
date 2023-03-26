extends Node

class_name Distribuciones

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func factorial(n, x=1):
	if (n <= 0):
		return x
	else:
		return factorial(n - 1, x * n)

func poisson(lambda, x):
	var numerador = exp(-lambda)*(lambda**x)
	var denominador = factorial(x)
	return numerador / denominador

func exponencial(mu, x):
	return 1 - exp(-mu * x)
	
	
func randv_histogram(values = [], probabilities = []):
	var bag = []
	var sum = 0
	for item in probabilities:
		assert(typeof(item) == TYPE_INT || typeof(item) == TYPE_FLOAT)
		bag.append(item)
		sum += item
	for item in bag:
		bag[item] = bag[item] / sum
		
	var value = randf()
	var running_total = 0
	var index = 0
	while running_total < value:
		running_total += bag[index]
		index += 1
	return values[index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
