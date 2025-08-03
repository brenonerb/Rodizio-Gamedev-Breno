extends Camera2D

var yowch := 0


func _process(delta: float) -> void:
	if yowch > 0:
		offset = lerp(offset, Vector2(randf_range(-yowch, yowch), randf_range(-yowch, yowch)), 0.2)
		yowch -= 1
		if yowch == 0:
			offset = Vector2.ZERO


func _on_player_obj_yowch(shake_amount: int) -> void:
	yowch = shake_amount
	$"../../CanvasLayer/Flash/AnimationPlayer".play("flash")
