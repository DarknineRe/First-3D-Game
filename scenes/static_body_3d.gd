extends StaticBody3D

@export var touch_time_to_explode: float = 5.0

var timers := {}  # player_id -> elapsed time

func _ready():
	$Trigger.body_entered.connect(_on_body_entered)
	$Trigger.body_exited.connect(_on_body_exited)
	set_process(true)
	$Explosion.emitting = false  # particles off initially

func _process(delta):
	for player_id in timers.keys():
		timers[player_id] += delta
		if timers[player_id] >= touch_time_to_explode:
			var player = _get_player_by_id(player_id)
			if player:
				_explode(player)
			timers.erase(player_id)  # reset timer for safety

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return
	var id = body.get_instance_id()
	if not timers.has(id):
		timers[id] = 0.0

func _on_body_exited(body):
	var id = body.get_instance_id()
	if timers.has(id):
		timers.erase(id)  # reset timer if player leaves

func _get_player_by_id(id):
	for body in $Trigger.get_overlapping_bodies():
		if body.get_instance_id() == id:
			return body
	return null

func _explode(player):
	if not is_instance_valid(player):
		return
	# play particle explosion at the item's location
	$Explosion.global_transform.origin = player.global_transform.origin
	$Explosion.emitting = true
	# remove the player
	player.queue_free()
