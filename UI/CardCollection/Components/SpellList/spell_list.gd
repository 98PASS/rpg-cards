#class_name SpellList extends PanelContainer
class_name SpellList extends FoldableContainer

@onready var spell_set_grid_container: SpellSetGridContainer = %SpellSetGridContainer

func add_spell(spell_card : SpellCardUI)->void:
	spell_set_grid_container.add_child(spell_card.duplicate())

func sort_spells(sort_criteria := SpellSetGridContainer.SpellSortProperty.SpellName )->void:
	spell_set_grid_container.sort_children(sort_criteria)
