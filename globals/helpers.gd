extends Node

func subtract_array(a: Array, b: Array) -> Array:
	return a.filter(func(item): return not b.has(item))	
