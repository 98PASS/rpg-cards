class_name CardVisualization extends HBoxContainer


@export var current_spell : SpellResource = null


@onready var spell_card: SpellCardUI = %SpellCard
@onready var spell_description_text: RichTextLabel = %SpellDescriptionText
@onready var at_higher_levels_panel_container: PanelContainer = %AtHigherLevelsPanelContainer
@onready var at_higher_levels_text: RichTextLabel = %AtHigherLevelsText

func _ready() -> void:
	if current_spell:
		set_spell(current_spell)

func set_spell(spell : SpellResource):
		current_spell=spell
		_fill_info()

func _fill_info()->void:
		spell_card.set_spell(current_spell)
		spell_description_text.text = current_spell.description
		at_higher_levels_text.text = current_spell.at_higher_levels
		at_higher_levels_panel_container.visible = not current_spell.at_higher_levels.is_empty()
