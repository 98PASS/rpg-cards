extends Node

func _ready() -> void:
	process_all_entries("res://Card/Data/brute_data/rpg-cards-processed.json")

func process_all_entries(json_path : String)->void:
	var file_open = FileAccess.open(json_path,FileAccess.READ)
	var text_data = JSON.parse_string(file_open.get_as_text())
	for text_instance in text_data:
		process_single_entry(text_instance)
	file_open.close()

func process_single_entry(text_instance : Dictionary)->void:
	#print(text_instance,"\n\n")
	var contents = text_instance["contents"] #look here
	#print(contents)
	var spell_name = ""
	var circle : int =0
	var school = ""
	var casting_time = ""
	var spell_range = ""
	var components = ""
	var duration = ""
	var description = ""
	var at_hl = ""
	var in_at_hl_section = false
	var tags : Array = text_instance["tags"]
	spell_name = text_instance["title"]

	for text_item in contents:
		var split_contents = text_item.split(" ")
		#print(split_contents)
		match split_contents[0]:
			"subtitle":
				match split_contents[2]:
					"level":
						circle = int(split_contents[3])
						school = split_contents[4]
					_:
						school = split_contents[2]
						circle = 0
			"property":
				var splitted = text_item.split(" | ")
				var key = splitted[1]
				var value = splitted[2]
				match key:
					"Casting Time":
						casting_time = value
					"Range":
						spell_range = value
					"Components":
						components = value
					"Duration":
						duration = value
					_:
						printerr("Property not recognized",get_stack())
			"description":
				# Se estivermos na seção "At Higher Levels", adiciona à at_hl
				if in_at_hl_section:
					if at_hl != "":
						at_hl += "\n"
					at_hl += "\t-" + text_item.split(" | ")[2]
				else:
					# Se não, é uma descrição geral (não deve acontecer neste formato)
					printerr("Description outside At Higher Levels section")
			"section":
				var splitted = text_item.split(" | ")
				if splitted[1] == "At higher levels":
					in_at_hl_section = true
					#at_hl = "\t-" + splitted[1] + ":"
				else:
					# Outras seções podem ser tratadas aqui
					printerr("Section not recognized in file structure.",get_stack())
			"text":
				var splitted = text_item.split(" | ")
				if in_at_hl_section:
					# Text dentro da seção At Higher Levels
					if at_hl != "":
						at_hl += "\n"
					at_hl += "\t-" + splitted[1]
				else:
					# Text na descrição principal
					if description != "":
						description += '\n'
					description += "\t-" + splitted[1]
			"bullet":
				var splitted = text_item.split(" | ")
				if in_at_hl_section:
					# Bullet dentro da seção At Higher Levels
					if at_hl != "":
						at_hl += "\n"
					at_hl += "\t\t-" + splitted[1]
				else:
					# Bullet na descrição principal
					if description != "":
						description += '\n'
					description += "\t\t-" + splitted[1]
			"rule":
				# Regra visual - pode marcar uma separação, mas não processamos
				pass
			_:
				printerr("Tipo não reconhecido: ", split_contents[0])

	var dic_spell = {
		"spell_name": spell_name,
		"circle": circle,
		"school": school,
		"casting_time": casting_time,
		"spell_range": spell_range,
		"components": components,
		"duration": duration,
		"description": description,
		"at_higher_levels": at_hl,
		"tags": tags
	}
	var spelly : SpellResource = SpellResource.create_from_processed_data(dic_spell)
	var treated_spell_name = treat_spell_name_to_save(spelly.spell_name)
	var error = ResourceSaver.save(spelly,("res://Card/Data/Spells/"+treated_spell_name+".res"))

	if error != OK:
		print(error)
	else:
		print("Done saving [",spelly.spell_name,".res]")

func treat_spell_name_to_save(spell_name : String)->String:
	var split = spell_name.split("/")
	return "".join(split)
