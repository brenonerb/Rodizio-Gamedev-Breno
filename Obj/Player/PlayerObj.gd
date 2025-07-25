extends CharacterBody2D

const YSpeed = 20.0
const MaxYSpeed = 200.0
const YDeaccelerate = 5.0
const HitSpeed = 200.0

var XSpeed: float
const TopXSpeed = 150.0
const XAcceleration = 5.0
var InitialBoost: bool = false

func _ready() -> void:
	XSpeed = 0.0

func _physics_process(delta: float) -> void:
	if GameController.StartGame == true:
		if InitialBoost == false:
			XSpeed = TopXSpeed
			InitialBoost = true
		HandleMovement()

func HandleMovement():
	if XSpeed < TopXSpeed:
		XSpeed += XAcceleration
	if XSpeed >= TopXSpeed:
		XSpeed = TopXSpeed
		GameController.SpawnablesFlag = true
		
	velocity.x = XSpeed
	var direction := Input.get_axis("Up", "Down")
	if direction > 0 and velocity.y < MaxYSpeed:
		velocity.y += YSpeed
	if direction < 0 and velocity.y > -MaxYSpeed:
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
		XSpeed = -200.0
		GameController.SpawnablesFlag = false
		area.queue_free()
		if GameController.HP != 0: GameController.HP -= 1
		else: GameController.GameOverFunc()
