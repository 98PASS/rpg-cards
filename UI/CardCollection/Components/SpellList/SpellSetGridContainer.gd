class_name SpellSetGridContainer extends GridContainer
const SPELL_CARD_UI = preload("uid://dne2uoxl1puwx")

# Propriedade personalizada para ordenação
enum SpellSortProperty{
	SpellName,
	SpellCircle,
	SpellSchool
}

@export var sort_property := SpellSortProperty.SpellName
@export var auto_sort_on_ready: bool = false
@export var sort_case_sensitive: bool = false

func _ready():
	if auto_sort_on_ready:
		call_deferred("sort_children")


func add_spell_card(spell_card : SpellCardUI)->void:
	add_child(spell_card.duplicate())

func sort_children(sort_criteria : SpellSortProperty = sort_property):
	sort_property = sort_criteria
	var children = get_children()
	if children.size() <= 1:
		return
	# Ordenar com base na propriedade especificada
	children.sort_custom(func(a, b):
		var value_a = _get_sort_value(a)
		var value_b = _get_sort_value(b)
		if sort_property == SpellSortProperty.SpellName:
			if not sort_case_sensitive:
				value_a = value_a.to_lower()
				value_b = value_b.to_lower()
		return value_a < value_b
	)
	# Reordenar na árvore de cena
	_reorder_children(children)

func _get_sort_value(node: Node):
	match sort_property:
		SpellSortProperty.SpellName:
			return node.spell.spell_name
		SpellSortProperty.SpellCircle:
			return node.spell.circle
		SpellSortProperty.SpellSchool:
			return node.spell.school
		_:
			return node.name

func _reorder_children(children: Array):
	# Método mais eficiente usando move_child
	var target_index = 0
	for child in children:
		var current_index = get_child_count() - 1
		while get_child(current_index) != child:
			current_index -= 1
		
		if current_index != target_index:
			move_child(child, target_index)
		
		target_index += 1
