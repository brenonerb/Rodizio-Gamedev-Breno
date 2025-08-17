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

@onready var pernas := $Rolima/Pernas
@onready var corpo := $Rolima/Corpo
@onready var sombra_pernas := $Sombra/Pernas
@onready var sombra_corpo := $Sombra/Corpo
# Essas variáveis são alteradas no AnimationPlayer
# Serve para fazer a animação do carrinho descendo
# sem ele colidir com as bordas do nível
@export var invencivel := false
@export var spawnando := false
const MORTO = preload("res://Obj/Morto/morto.tscn")
const MARQUINHA = preload("res://Obj/MarcasDePneu/marca_de_pneu.tscn")
@onready var perna_esquerda := $Rolima/Pernas/RodaEsquerda
@onready var perna_direita := $Rolima/Pernas/RodaDireita
@onready var level := get_parent()
var prev_perna_rot := 0.0
@export var skid_volume_curve: Curve
@export var skid_pitch_curve: Curve

@export var motor_volume_curve: Curve
@export var motor_pitch_curve: Curve

signal yowch(shake_amount: int)
signal recuperou

func _ready() -> void:
	$Skid.volume_linear = 0.0
	$Motor.volume_linear = 0.0
	XSpeed = 0.0
	InitialBoost = false
	GameController.game_started.connect(func():
			$AnimationPlayer.play("spawn")
	)
	GameController.hundred_points.connect(func(): $"100Points".play())

func _physics_process(_delta: float) -> void:
	if GameController.StartGame:
		if not InitialBoost:
			InitialBoost = true
			XSpeed = TopXSpeed
		HandleMovement()
		$Skid.volume_linear = skid_volume_curve.sample(abs(prev_perna_rot))
		$Skid.pitch_scale = skid_pitch_curve.sample(abs(prev_perna_rot))
		
		$Motor.volume_linear = motor_volume_curve.sample(XSpeed / MaxXSpeed if XSpeed > 0 else 0)
		$Motor.pitch_scale = motor_pitch_curve.sample(XSpeed / MaxXSpeed if XSpeed > 0 else 0)
		handle_marquinhas()

func HandleMovement():
	TopXSpeed = GameController.TopXSpeed
	if XSpeed < TopXSpeed:
		XSpeed += XAcceleration
	if XSpeed >= TopXSpeed:
		XSpeed = TopXSpeed

	velocity.x = XSpeed
	var direction := Input.get_axis("Up", "Down") if not spawnando else 0.0
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

	pernas.rotation_degrees = velocity.y / 4.0
	corpo.rotation_degrees = lerp(corpo.rotation_degrees, velocity.y / 4.0, 0.05)
	sombra_pernas.rotation = pernas.rotation
	sombra_corpo.rotation = corpo.rotation

func handle_marquinhas():
	if abs(prev_perna_rot - pernas.global_rotation) > 0.03:
		var marca = MARQUINHA.instantiate()
		marca.global_position = perna_esquerda.global_position
		marca.global_rotation = perna_esquerda.global_rotation
		level.add_child(marca)
		marca = MARQUINHA.instantiate()
		marca.global_position = perna_direita.global_position
		marca.global_rotation = perna_direita.global_rotation
		level.add_child(marca)
	prev_perna_rot = pernas.global_rotation


func _on_player_coliisions_area_entered(area: Area2D) -> void:
	if area.is_in_group("TopArea") and not spawnando:
		velocity.y = HitSpeed
		XSpeed = 50.0
		$BounceSound.play()

	if area.is_in_group("BottomArea") and not spawnando:
		velocity.y = -HitSpeed
		XSpeed = 50.0
		$BounceSound.play()

	if area.is_in_group("Obstacle") and not invencivel:
		XSpeed = -GameController.TopXSpeed
		area.get_parent().get_parent().yowch()
		if GameController.HP != 1:
			yowch.emit(50)
			$AnimationPlayer.stop()
			$AnimationPlayer.play("speen")
			GameController.HP -= 1
			$HitSound.play() 
		else: 
			yowch.emit(100)
			InitialBoost = false
			GameController.GameOverFunc()
			$AnimationPlayer.play("RESET")
			var morto = MORTO.instantiate()
			morto.global_position = global_position
			get_parent().add_child(morto)
			$DeadSound.play()
			$Skid.volume_linear = 0.0
			$Motor.volume_linear = 0.0


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "speen":
		recuperou.emit()
