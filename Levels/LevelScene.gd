extends Node2D

@onready var SpawnerArea: ColorRect = $SpawnerArea
@onready var TopArea: Area2D = $TopArea
@onready var BottomArea: Area2D = $BottomArea

@onready var ScoreText: RichTextLabel = $GameUI/ScoreText

var SpawnerReady: bool = false
@export var Obstacles: PackedScene

func _ready() -> void:
	$GameUI/GameOverText.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	$Timer.wait_time = GameController.SpawnTime
	
	var VisualGO: bool = false
	if GameController.GameOver:
		if not VisualGO:
			VisualGO = true
			ShowGameOver()
		if Input.is_action_just_pressed("Start"):
			GameController.StartGameFunc()
			get_tree().reload_current_scene()
	
func SpawnerControl():
	$Timer.start()

func SpawnObstacle():
	var ObjSpawn = Obstacles.instantiate()
	add_child(ObjSpawn)
	ObjSpawn.position = SpawnerArea.position + Vector2(0, 240.0)

func ShowGameOver():
	$Timer.stop()
	$GameUI/GameOverText.visible = true
	$GameUI/GameOverText.position.x = get_viewport().get_camera_2d().global_position.x - 213
	$GameUI/GameOverText.text = str("""[center][font_size=32]FIM DE JOGO[/font_size]
	Pontuação Final: """, GameController.Score)
	ScoreText.text = str("[right]PRESSIONE ESPAÇO PARA COMEÇAR[/right]")
	SpawnerReady = false


func _on_timer_timeout() -> void:
	if GameController.SpawnablesFlag: SpawnObstacle()
	else: pass
