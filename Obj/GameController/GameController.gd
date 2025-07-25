extends Node

var StartGame: bool = false

var HP: int
var Score: int
var StartScore: bool = false

var SpawnablesFlag: bool = false

func _process(delta: float) -> void:
	print(Score)
	if StartGame and StartScore == false:
		StartScore = true
		AddToScore()

func AddToScore():
	while StartGame:
		Score += 1
		await get_tree().create_timer(0.1).timeout

func StartGameFunc():
	HP = 3
	StartGame = true
	SpawnablesFlag = true
	print("Jogo começou")

func GameOverFunc():
	StartGame = false
	StartScore = false
	print("Jogo terminou")
