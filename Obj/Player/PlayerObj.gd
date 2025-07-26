extends CharacterBody2D

const YSpeed = 7.0
const MaxYSpeed = 200.0
const YDeaccelerate = 5.0
const HitSpeed = 200.0

var XSpeed: float
var TopXSpeed: float
const MaxXSpeed = 300.0
const XAcceleration = 5.0
var InitialBoost: bool = false

func _ready() -> void:
	XSpeed = 0.0
	InitialBoost = false

func _physics_process(_delta: float) -> void:
	print(XSpeed)
	print(InitialBoost)
	print(GameController.SpawnablesFlag)
	if GameController.StartGame:
		if not InitialBoost:
			InitialBoost = true
			XSpeed = TopXSpeed
		HandleMovement()

func HandleMovement():
	TopXSpeed = GameController.TopXSpeed
	if XSpeed < TopXSpeed:
		XSpeed += XAcceleration
	if XSpeed >= TopXSpeed:
		XSpeed = TopXSpeed
		GameController.SpawnablesFlag = true
		
	velocity.x = XSpeed
	var direction := Input.get_axis("Up", "Down")
	if direction > 0 and velocity.y < MaxYSpeed:
		velocity.y += YSpeed
	elif direction < 0 and velocity.y > -MaxYSpeed:
		velocity.y -= YSpeed
	else:
		if velocity.y > 0:
			velocity.y -= YDeaccelerate
		elif velocity.y < 0:
			velocity.y += YDeaccelerate
	move_and_slide()


func _on_player_coliisions_area_entered(area: Area2D) -> void:
	if area.is_in_group("TopArea"):
		velocity.y = HitSpeed
		XSpeed = 50.0

	if area.is_in_group("BottomArea"):
		velocity.y = -HitSpeed
		XSpeed = 50.0

	if area.is_in_group("Obstacle"):
		XSpeed = -GameController.TopXSpeed
		GameController.SpawnablesFlag = false
		area.queue_free()
		if GameController.HP != 1:
			GameController.HP -= 1
		else:
			InitialBoost = false
			GameController.GameOverFunc() 
