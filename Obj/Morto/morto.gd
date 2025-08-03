extends Node2D

func _ready() -> void:
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	$CPUParticles2D3.emitting = true
	GameController.game_started.connect(func():
			await get_tree().create_timer(3).timeout
			queue_free()
	)
