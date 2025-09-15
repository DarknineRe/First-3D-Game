# PlateTrigger.gd
extends Area3D

@export var explosion_scene: PackedScene = preload("res://explosion.tscn")
@export var trigger_time: float = 5.0 # seconds player must stay

var player_inside := false
var timer := 0.0

func _process(delta):
	if player_inside:
		timer += delta
		if timer >= trigger_time:
			_trigger_explosion()
	else:
		timer = 0.0

func _on_area_body_entered(body: Node):
	if body.is_in_group("player"):
		player_inside = true

func _on_area_body_exited(body: Node):
	if body.is_in_group("player"):
		player_inside = false

func _trigger_explosion():
	var player = get_tree().get_nodes_in_group("player")[0] # adjust path to your player
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = player.global_position
	
	# Call your player hit function
	var main = get_tree().current_scene
	if main.has_method("_on_player_hit"):
		main._on_player_hit()
	
	# Reset timer so it doesn't trigger repeatedly
	timer = 0.0
	player_inside = false
