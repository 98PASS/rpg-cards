extends Node2D

@export var spell : SpellResource = null
@onready var spell_name_label: Label = $Card70x120/VBoxContainer/SpellNameLabel
@onready var spell_school_label: Label = $Card70x120/VBoxContainer/HBoxContainer/SpellSchoolLabel
@onready var spell_circle_label: Label = $Card70x120/VBoxContainer/HBoxContainer/SpellCircleLabel
@onready var spell_cast_time_label: Label = $Card70x120/VBoxContainer/HBoxContainer2/SpellCastTimeLabel
@onready var spell_range_label: Label = $Card70x120/VBoxContainer/HBoxContainer3/SpellRangeLabel
@onready var spell_duration_label: Label = $Card70x120/VBoxContainer/HBoxContainer4/SpellDurationLabel
#@onready var spell_components_label: Label = $Card70x120/VBoxContainer/HBoxContainer5/SpellComponentsLabel
#tags (ritual and concentration)
@onready var ritual_panel_tag: PanelContainer = $Card70x120/HBoxContainer/RitualPanelTag
@onready var concentration_panel_tag: PanelContainer = $Card70x120/HBoxContainer/ConcentrationPanelTag
#components
@onready var texture_rect_v: TextureRect = $Card70x120/VBoxContainer/HBoxContainer5/HBoxContainer/TextureRectV
@onready var texture_rect_s: TextureRect = $Card70x120/VBoxContainer/HBoxContainer5/HBoxContainer/TextureRectS
@onready var texture_rect_m: TextureRect = $Card70x120/VBoxContainer/HBoxContainer5/HBoxContainer/TextureRectM

func _ready() -> void:
	_update_full_card()
	print(spell)



func _update_full_card()->void:
	spell_name_label.text = spell.spell_name
	spell_school_label.text = spell.school
	spell_circle_label.text = str(spell.circle)
	spell_cast_time_label.text = spell.casting_time
	spell_range_label.text = spell.spell_range
	spell_duration_label.text = spell.duration
	#spell_components_label.text = spell.components
	ritual_panel_tag.visible = spell.ritual
	concentration_panel_tag.visible = spell.concentration
	
	texture_rect_v.visible = spell.verbal
	texture_rect_s.visible = spell.somatic
	texture_rect_m.visible = spell.material
