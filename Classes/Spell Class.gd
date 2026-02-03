class_name SpellResource extends Resource

enum MagicSchool {
	ABJURATION,
	CONJURATION,
	DIVINATION,
	ENCHANTMENT,
	EVOCATION,
	ILLUSION,
	NECROMANCY,
	TRANSMUTATION
}

@export var spell_name: String = ""
@export var circle: int = 0
@export var school: MagicSchool
@export var casting_time: String = ""
@export var spell_range: String = ""  # Usando String pois pode ter "Touch", "Self", etc.
@export var components: String = ""
@export var duration: String = ""
@export var concentration: bool = false
@export var ritual: bool = false
@export var verbal : bool = false
@export var somatic : bool = false
@export var material : bool = false
@export var material_components : String = ""
@export_multiline var description: String = ""
@export_multiline var at_higher_levels: String = ""
@export var tags: Array = []

# Função para formatar a saída igual ao exemplo
func _to_string() -> String:
	var output = "Spell Name:\t" + spell_name + "\n"
	output += "Circle:\t" + str(circle) + "\nSchool:\t" + magic_school_to_string(school) + "\n"
	output += "Casting Time:\t" + casting_time + "\nRange:\t" + spell_range + "\nComponents:\t" + components + "\nDuration:\t" + duration + "\n"
	output += "Description:\n" + description + "\n"
	if at_higher_levels != "":
		output += "At Higher Levels:\n" + at_higher_levels
		
	#output += "\nSpell Notes:\n\t-Concentration:\t"+str(concentration) +"\n\t-Ritual:\t"+str(ritual)
	return output

# Função para criar um SpellResource a partir do dicionário processado
static func create_from_processed_data(data: Dictionary) -> SpellResource:
	var spell = SpellResource.new()
	spell.spell_name = data.get("spell_name", "")
	spell.circle = data.get("circle", 0)
	spell.school = _string_to_magic_school(data.get("school", "")) 
	spell.casting_time = data.get("casting_time", "")
	spell.spell_range = data.get("spell_range", "")
	spell.components = data.get("components", "")
	spell.duration = data.get("duration", "")
	spell.description = data.get("description", "")
	spell.at_higher_levels = data.get("at_higher_levels", "")
	spell.tags = data.get("tags", [])
	_treat_details(spell)
	_treat_components(spell)
	
	return spell

static func _treat_details(spell: SpellResource) -> void:
	spell.ritual = spell.casting_time.find("Ritual") != -1
	spell.concentration = spell.duration.begins_with("Concentration")

static func _treat_components(spell: SpellResource) -> void:
	var spell_components := spell.components
	if spell_components.is_empty():
		return

	# Flags rápidas (string curta)
	spell.verbal = spell_components.find("V") != -1
	spell.somatic = spell_components.find("S") != -1
	spell.material = spell_components.find("M") != -1

	# Extração de material (se existir)
	var open := spell_components.find("(")
	if open == -1:
		return

	var close := spell_components.find(")", open)
	if close == -1:
		return

	spell.material_components = spell_components.substr(
		open + 1,
		close - open - 1
	).strip_edges()

static func _string_to_magic_school(value: String) -> MagicSchool:
	match value.to_lower():
		"abjuration": return MagicSchool.ABJURATION
		"conjuration": return MagicSchool.CONJURATION
		"divination": return MagicSchool.DIVINATION
		"enchantment": return MagicSchool.ENCHANTMENT
		"evocation": return MagicSchool.EVOCATION
		"illusion": return MagicSchool.ILLUSION
		"necromancy": return MagicSchool.NECROMANCY
		"transmutation": return MagicSchool.TRANSMUTATION
		_: return MagicSchool.ABJURATION # default / fallback

static func magic_school_to_string(school: MagicSchool) -> String:
	match school:
		MagicSchool.ABJURATION: return "Abjuration"
		MagicSchool.CONJURATION: return "Conjuration"
		MagicSchool.DIVINATION: return "Divination"
		MagicSchool.ENCHANTMENT: return "Enchantment"
		MagicSchool.EVOCATION: return "Evocation"
		MagicSchool.ILLUSION: return "Illusion"
		MagicSchool.NECROMANCY: return "Necromancy"
		MagicSchool.TRANSMUTATION: return "Transmutation"
		_: return "Unknown"
