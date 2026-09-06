@tool
extends EditorScript
var count_code := 0
var count_comments := 0
var count_total := 0
 
func _run():
	count_dir("res://")
	print("scanned complete")
	OS.alert("%s lines of code\n%s comments\n%s total lines" % [count_code, count_comments, count_total])
 

func count_dir(path: String):
	var dir := DirAccess.open(path)
	if not dir:
		print("FAILED to open: ", path, " error: ", DirAccess.get_open_error())
		return

	var directories = DirAccess.get_directories_at(path)
	for d in directories:
		if d == "addons" or d.begins_with("."):
			continue
		count_dir(path.path_join(d))

	var files = DirAccess.get_files_at(path)
	for f in files:
		if not f.get_extension() == "gd":
			continue
		var file := FileAccess.open(path.path_join(f), FileAccess.READ)
		if not file:
			print("FAILED to open file: ", path.path_join(f))
			continue
		var lines = file.get_as_text().split("\n")

		for line in lines:
			count_total += 1
			if line.strip_edges().begins_with("#"):
				count_comments += 1
				continue
			if line.strip_edges() != "":
				count_code += 1
