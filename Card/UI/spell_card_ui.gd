class_name SpellCardUI extends MarginContainer

@export var spell : SpellResource = null

@onready var ritual_panel_tag: PanelContainer = %RitualPanelTag
@onready var concentration_panel_tag: PanelContainer = %ConcentrationPanelTag
@onready var spell_name_label: Label = %SpellNameLabel
@onready var spell_school_label: Label = %SpellSchoolLabel
@onready var spell_circle_label: Label = %SpellCircleLabel
@onready var spell_cast_time_label: Label = %SpellCastTimeLabel
@onready var spell_range_label: Label = %SpellRangeLabel
@onready var spell_duration_label: Label = %SpellDurationLabel
@onready var texture_rect_v: TextureRect = %TextureRectV
@onready var texture_rect_s: TextureRect = %TextureRectS
@onready var texture_rect_m: TextureRect = %TextureRectM


func _ready() -> void:
	if spell:
		_update_full_card()
	else:
		printerr("Spell data not initialized in ",name,"\n",get_stack())

func _update_full_card()->void:
	const cantrip_string = "Cantrip"
	const level_string = "Level "
	spell_name_label.text = spell.spell_name
	spell_school_label.text = SpellResource.magic_school_to_string(spell.school)
	spell_circle_label.text = level_string+str(spell.circle) if spell.circle > 0 else cantrip_string
	spell_cast_time_label.text = spell.casting_time
	spell_range_label.text = spell.spell_range
	spell_duration_label.text = spell.duration
	ritual_panel_tag.visible = spell.ritual
	concentration_panel_tag.visible = spell.concentration
	texture_rect_v.visible = spell.verbal
	texture_rect_s.visible = spell.somatic
	texture_rect_m.visible = spell.material

func set_spell(spell_value : SpellResource):
	spell = spell_value
	_update_full_card()
