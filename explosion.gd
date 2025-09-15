extends Node3D

@onready var debris: GPUParticles3D = $Debris
@onready var smoke: GPUParticles3D = $Smoke
@onready var fire: GPUParticles3D = $Fire

func _ready() -> void:
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	MusicPlayer.explosion.play()
	await get_tree().create_timer(2).timeout
	queue_free()
	
