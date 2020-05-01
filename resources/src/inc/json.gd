extends Node

func read_file(path):
	var fullpath = "res://resources/" + path + ".json"
	var file = File.new()
	file.open(fullpath, file.READ)
	var result = JSON.parse(file.get_as_text())
	
	if result.error == OK:
		return result.result
	else:
		print("ERROR PARSING DATA FROM " + fullpath)
		print("Error " + str(result.error) + ": '" + result.error_string + "' on line " + str(result.error_line));
