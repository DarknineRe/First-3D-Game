extends CanvasLayer

@export var combo_reset_time: float = 2.0
@onready var combo_bar: ProgressBar = $ProgressBar
@onready var combo_label: Label = $Label
@onready var score_label: Label = $ScoreLabel 

var combo_count: int = 0
var combo_timer: float = 0.0
var combo_active: bool = false
var score: int = 0

func _process(delta: float) -> void:
	if combo_active:
		combo_timer -= delta
		if combo_timer <= 0:
			_reset_combo()
		else:
			combo_bar.value = combo_timer

func add_combo():
	combo_count += 1
	combo_active = true
	combo_timer = combo_reset_time
	combo_bar.max_value = combo_reset_time
	combo_bar.value = combo_timer
	
	if combo_count > 1:
		combo_label.text = "%dx" % combo_count
	else:
		combo_label.text = "1x"

func _reset_combo():
	combo_count = 0
	combo_active = false
	combo_timer = 0
	combo_bar.value = 0
	combo_label.text = "0x"

func _on_mob_squashed():
	score += combo_count if combo_count > 0 else 1
	add_combo() 
	score_label.text = "Score : %s" % score
