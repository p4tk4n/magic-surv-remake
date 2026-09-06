extends Node

func subtract_array(a: Array, b: Array) -> Array:
	return a.filter(func(item): return not b.has(item))	

func add_array(a: Array, b: Array) ->  Array:
	var result: Array = a.duplicate()
	for item in b:
		result.append(item)
	return result
