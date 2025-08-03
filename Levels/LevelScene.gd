extends Node2D

@onready var SpawnerArea: ColorRect = $SpawnerArea
@onready var TopArea: Area2D = $TopArea
@onready var BottomArea: Area2D = $BottomArea

@onready var ScoreText: Label = $CanvasLayer/GameUI/Score
@onready var RecordText: Label = $CanvasLayer/GameUI/Record

var SpawnerReady: bool = false
@export var Obstacles: PackedScene

var new_record := false
var current_record := 0
var VisualGO: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	SpawnerArea.position.x = get_viewport().get_camera_2d().global_position.x + 300
	TopArea.position.x = get_viewport().get_camera_2d().global_position.x -213
	BottomArea.position.x = get_viewport().get_camera_2d().global_position.x -213

	if Input.is_action_just_pressed("Start") and GameController.StartGame == false:
		new_record = false
		VisualGO = false
		$CanvasLayer/GameUI/Coroinha.modulate = Color.WHITE
		$CanvasLayer/GameUI/Record.modulate = Color.WHITE
		GameController.StartGameFunc()
		$CanvasLayer/GameUI/AnimationPlayer.play("out")

	if GameController.StartGame:
		ScoreText.text = str(GameController.Score)
		if GameController.Score > current_record:
			new_record = true
			current_record = GameController.Score
			RecordText.text = str(current_record)

	if GameController.StartGame and SpawnerReady == false:
		SpawnerReady = true
		SpawnerControl()
	if GameController.SpawnTime > 0:
		$Timer.wait_time = GameController.SpawnTime

	if GameController.GameOver:
		if not VisualGO:
			VisualGO = true
			ShowGameOver()

func SpawnerControl():
	$Timer.start()

func SpawnObstacle():
	var ObjSpawn = Obstacles.instantiate()
	add_child(ObjSpawn)
	ObjSpawn.position = SpawnerArea.position + Vector2(0, 240.0)

func ShowGameOver():
	$Timer.stop()
	$CanvasLayer/GameUI/AnimationPlayer.play("in")
	if new_record:
		$CanvasLayer/GameUI/Coroinha.modulate = Color.YELLOW
		$CanvasLayer/GameUI/Record.modulate = Color.YELLOW
	SpawnerReady = false


func _on_timer_timeout() -> void:
	if GameController.SpawnablesFlag: SpawnObstacle()
	else: pass

func _on_player_obj_yowch(_shake_amount: int) -> void:
	$Timer.stop()


func _on_player_obj_recuperou() -> void:
	$Timer.start(1.5)
