class_name CardCollection extends TabContainer

const SPELL_LIST_CONTAINER = preload("uid://cc7slhtw4a2wk")
const SPELL_CARD_UI = preload("uid://dne2uoxl1puwx")


@export var spells_path := "res://Card/Data/Spells/"
@onready var all_spell_list_container: SpellListContainer = $All

var spell_list_containers_dic :Dictionary[String,SpellListContainer]= {
}

var loaded_spells : Array[SpellResource] = []


func spell_has_tags(spell: SpellResource, tags: Array[String]) -> bool:
	# Retorna true apenas se a magia tiver TODAS as tags
	for tag in tags:
		if not spell.tags.has(tag):
			return false
	return true

func filter_spells(tags: Array[String]) -> Array[SpellResource]:
	# Filtra as magias que têm todas as tags especificadas
	return loaded_spells.filter(func(spell): return spell_has_tags(spell, tags))

func extract_spell_classes(spell : SpellResource)->Array:
	var filtered_tags = []
	for tag in spell.tags:
		if DataAutoload.all_classes.has(tag):
			filtered_tags.append(tag)
	return filtered_tags

func create_children_spell_lists()->void:
	for spellcasting_class in DataAutoload.all_classes:
		var spell_list_container := SPELL_LIST_CONTAINER.instantiate()
		spell_list_container.name = spellcasting_class
		spell_list_containers_dic[spellcasting_class]=spell_list_container
		add_child(spell_list_container)
	spell_list_containers_dic["All"] = all_spell_list_container

func fill_lists()->void:
	for spell in loaded_spells:
		var spell_card = create_spell_card(spell)
		var classes_that_use_this_spell = extract_spell_classes(spell)
		classes_that_use_this_spell.append("All")
		for class_tag in classes_that_use_this_spell:
			#print(class_tag)
			spell_list_containers_dic[class_tag].add_spell_card(spell_card.duplicate())
	for spell_container in spell_list_containers_dic.values():
		(spell_container as SpellListContainer).sort_spell_cards()

func _ready() -> void:
	create_children_spell_lists()
	load_all_spells()
	fill_lists()
	
	
	
	#var filtered = filter_spells(["Cleric","Cantrips"])
	#for spell in filtered:
		#print(spell.spell_name)
	#
	
	#for spell in loaded_spells:
		##create_spell_card(spell)
		#spell.tags.remove_at(0)
		#spell.tags.remove_at(0)
		#var level  = spell.tags.pop_front()
		#var school = spell.tags.pop_front()
		#for tag in spell.tags:
			#if tag == "concentration" or tag == "ritual":
				#break
			#class_circle_school[tag][level][school]+=spell
		#print(class_circle_school)
	
	
	#all_spell_list_container.sort_spell_cards()

func load_all_spells():
	var dir := DirAccess.open(spells_path)
	if dir == null:
		push_error("Not possible opening folder: " + spells_path+"\n",get_stack())
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# Ignora pastas e arquivos ocultos
		if not dir.current_is_dir() and file_name.ends_with(".res"):
			var resource_path := spells_path + file_name
			var spell := load(resource_path)
			loaded_spells.append(spell)
		file_name = dir.get_next()
	dir.list_dir_end()

func create_spell_card(spell: SpellResource)->SpellCardUI:
	var card := SPELL_CARD_UI.instantiate()
	card.spell = spell
	card.name = spell.spell_name

	for tag : String in spell.tags:
		card.add_to_group(tag,true)

	return card
	#all_spell_list_container.add_spell_card(card)
