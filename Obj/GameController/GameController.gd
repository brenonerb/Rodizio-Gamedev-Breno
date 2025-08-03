extends Node

var StartGame: bool = false
var GameOver: bool = false

var HP: int
var Score: int
var StartScore: bool = false

var SpawnablesFlag: bool = false
var GameTime: float
var TopXSpeed: float
var SpawnTime: float

signal game_started

func _process(delta: float) -> void:
	if StartGame:
		if not StartScore:
			StartScore = true
			AddToScore()
		DifficultySetter(delta)

func AddToScore():
	while StartGame:
		Score += 1
		await get_tree().create_timer(0.1).timeout

func StartGameFunc():
	HP = 3
	StartGame = true
	GameOver = false
	SpawnablesFlag = true
	Score = 0
	TopXSpeed = 100.0
	SpawnTime = 3.0
	GameTime = 0
	game_started.emit()
	print("Jogo começou")

func GameOverFunc():
	StartGame = false
	StartScore = false
	GameOver = true
	print("Jogo terminou")

func DifficultySetter(delta: float):
	GameTime += delta
	if TopXSpeed < 300.0: TopXSpeed = 100.0 + GameTime * 10
	SpawnTime = 300.0 / TopXSpeed
