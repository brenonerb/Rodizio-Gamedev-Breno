extends Node2D

@onready var SpawnerArea: ColorRect = $SpawnerArea
@onready var TopArea: Area2D = $TopArea
@onready var BottomArea: Area2D = $BottomArea

@onready var ScoreText: RichTextLabel = $GameUI/ScoreText

var SpawnerReady: bool = false
@export var Obstacles: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SpawnerArea.position.x = get_viewport().get_camera_2d().global_position.x + 256
	TopArea.position.x = get_viewport().get_camera_2d().global_position.x -213
	BottomArea.position.x = get_viewport().get_camera_2d().global_position.x -213
	ScoreText.position.x = get_viewport().get_camera_2d().global_position.x - 213
	
	if Input.is_action_just_pressed("Start") and GameController.StartGame == false:
		GameController.StartGameFunc()
	
	if GameController.StartGame:
		ScoreText.text = str("[right]", GameController.Score, "[/right]")
	
	if GameController.StartGame and SpawnerReady == false:
		SpawnerReady = true
		SpawnerControl()
	
func SpawnerControl():
	while GameController.StartGame:
		if GameController.SpawnablesFlag:
			SpawnObstacle()
		await get_tree().create_timer(3.0).timeout

func SpawnObstacle():
	print("Spawnei!")
	var ObjSpawn = Obstacles.instantiate()
	add_child(ObjSpawn)
	ObjSpawn.position = SpawnerArea.position + Vector2(0, 240.0)
