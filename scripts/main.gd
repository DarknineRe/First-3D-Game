extends Node

@export var mob_scene: PackedScene
@onready var player: CharacterBody3D = $Player

func _ready():
	MusicPlayer.bgm.play()
	$UserInterface/Retry.hide()
	$UserInterface/Exit.hide()


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)

	# Spawn the mob by adding it to the Main scene.

	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/Combo._on_mob_squashed.bind())

func _on_player_hit():
	player.queue_free()
	$MobTimer.stop()
	$UserInterface/Retry.show()
	$UserInterface/Exit.show()
	MusicPlayer.bgm.stop()
	for mob in get_tree().get_nodes_in_group("enemy"):
		mob.queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
