extends KinematicBody2D
class_name Player

onready var player_sprite: Sprite = get_node("Texture")

var velocity: Vector2
var jump_count: int = 0
var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crounching: bool = false

var can_track_input: bool = true

export(int) var speed
export(int) var jump_speed
export(int) var player_gravity

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left') 
	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("ui_select") and jump_count < 2:
		jump_count += 1
		velocity.y = jump_speed
	pass
	
func actions_env() -> void:
	attack()
	crounch()
	defense()

func attack() -> void:
	var attack_condition: bool = not attacking and not crounching and not defending
	
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true

func crounch() -> void:
	if Input.is_action_just_pressed("crounch") and is_on_floor() and not defending :
		crounching = true
		can_track_input = false
	elif not defending:
		crounching = false
		can_track_input = true

func defense() -> void:
	if Input.is_action_just_pressed('defense') and is_on_floor() and not crounching:
		defending = true
		can_track_input = false
	elif not defending:
		defending = false
		can_track_input = true

func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity

