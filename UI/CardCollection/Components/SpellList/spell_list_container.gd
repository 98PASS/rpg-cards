class_name SpellListContainer extends VBoxContainer
const FOLADBLE_SPELL_LIST = preload("uid://buog4baacng4i")

var sublists: Dictionary[String,SpellList]={}


@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer


func _ready() -> void:
	for circle in DataAutoload.all_spell_levels:
		var spell_list:SpellList= FOLADBLE_SPELL_LIST.instantiate()
		spell_list.name = str(circle)
		spell_list.title = str(circle)
		sublists[circle]=spell_list
		v_box_container.add_child(spell_list)

func add_spell_list(spell_card_list : Array[SpellCardUI])->void:
	for card in spell_card_list:
		add_spell_card(card)
	sort_spell_cards()

func add_spell_card(spell_card : SpellCardUI)->void:
	var circle = spell_card.spell.tags[2]
	if not sublists.has(circle):
		var new_list :SpellList= FOLADBLE_SPELL_LIST.instantiate()
		new_list.name = circle
		new_list.title = circle
		sublists[circle]=new_list
		add_child(new_list)
	(sublists[circle] as SpellList).add_spell(spell_card)
	

func sort_spell_cards(sort_criteria := SpellSetGridContainer.SpellSortProperty.SpellName)->void:
	for item in sublists.values():
		(item as SpellList).sort_spells(sort_criteria)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			sort_spell_cards()
		1:
			sort_spell_cards(SpellSetGridContainer.SpellSortProperty.SpellCircle)
		2:
			sort_spell_cards(SpellSetGridContainer.SpellSortProperty.SpellSchool)
