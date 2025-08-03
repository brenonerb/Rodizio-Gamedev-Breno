extends Node2D

const DECORS = [
		preload("res://Obj/Background/florzinho.png"),
		preload("res://Obj/Background/marquinhas1.png"),
		preload("res://Obj/Background/marquinhas2.png"),
		preload("res://Obj/Background/marquinhas3.png"),
		preload("res://Obj/Background/matinho1.png"),
		preload("res://Obj/Background/matinho2.png"),
		preload("res://Obj/Background/pedrinhas1.png"),
		preload("res://Obj/Background/risquinhos.png"),
]


func _on_limite_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		position.x += 426
		var decors1 = $Sprite1/Decors
		$Sprite1.remove_child(decors1)
		$Sprite2/Decors.reparent($Sprite1, false)
		$Sprite3/Decors.reparent($Sprite2, false)
		for child in decors1.get_children():
			if randi() % 2 == 0:
				child.hide()
				continue
			else:
				child.show()
			child.position = Vector2(randi_range(-180, 180), randi_range(-82, 82))
			child.texture = DECORS.pick_random()
		$Sprite3.add_child(decors1, true)
