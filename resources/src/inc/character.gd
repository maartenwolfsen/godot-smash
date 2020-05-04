extends "res://resources/src/inc/json.gd"

func get_characters():
	return read_file('data/characters')

func get_characters_amount():
	return get_characters().size()
	
# Todo: move to own script
func get_character_by_key(key):
	var i = 0
	
	for character in get_characters():
		if i == key:
			return character
		
		i += 1

func get_character_portrait(character):
	return load(
		"res://resources/sprites/characters/" + character + "/portrait.png"
	)
