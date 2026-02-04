extends Node2D

@export var spell : SpellResource = null
@onready var spell_card_ui: SpellCardUI = $SpellCardUI

func _ready() -> void:
	if spell:
		spell_card_ui.spell = spell
