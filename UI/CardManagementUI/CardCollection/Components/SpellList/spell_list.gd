#class_name SpellList extends PanelContainer
class_name SpellList extends FoldableContainer


@onready var spell_set_flow_container: SpellSetFlowContainer = %SpellSetFlowContainer

func add_spell(spell_card : SpellCardUI)->void:
	spell_set_flow_container.add_spell_card(spell_card)

func sort_spells(sort_criteria := SpellSetFlowContainer.SpellSortProperty.SpellName )->void:
	spell_set_flow_container.sort_children(sort_criteria)
