extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ObstacleType = randi_range(0, 4)
	match ObstacleType:
		0:
			$SpecificObstacles/TopObstacle.visible = true
			$SpecificObstacles/TopObstacle/CollisionShape2D.disabled = false
		1:
			$SpecificObstacles/BottomObstacle.visible = true
			$SpecificObstacles/BottomObstacle/CollisionShape2D.disabled = false
		2:
			$SpecificObstacles/MiddleObstacle.visible = true
			$SpecificObstacles/MiddleObstacle/CollisionShape2D.disabled = false
		3:
			$SpecificObstacles/LosangoObstacle1.visible = true
			$SpecificObstacles/LosangoObstacle1/CollisionPolygon2D.disabled = false
		4:
			$SpecificObstacles/LosangoObstacle2.visible = true
			$SpecificObstacles/LosangoObstacle2/CollisionPolygon2D.disabled = false

func _process(_delta: float) -> void:
	if position.x < get_viewport().get_camera_2d().global_position.x -256: queue_free()
