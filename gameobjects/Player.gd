extends KinematicBody



export var speed = 8
export var running_speed = 10
export var jump_velocity = 8.5
export var mouse_sensitivity = 10
var current_speed
var acceleration = 0.9 # use to limit movement while in air
onready var animator = $AnimationTree

export var max_gravity = 19.78
export var gravity_alt_perectage = 0.7
onready var attack_area_shape = $Attack_area/attack_area_shape
var attack_step = 0
var combo_possible = false
var combo_requested = false
var gravity = 19.78
var mouse_input = Vector2()
var direction = Vector3()
var hp
var y_velocity = Vector3()
var velocity = Vector3()
var target_rotation = Vector3()

onready var camera = $Camera
onready var camera_v = $Camera/cam_v
onready var feet_col_shape = $stump_area/feets_shape
onready var UI = $UI
func _ready():
	get_tree().paused = false
	hp = 8
	camera.set_as_toplevel(true)
	current_speed = speed
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("up"):
		direction -= camera.global_transform.basis.z
	if Input.is_action_pressed("down"):
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		direction += camera.global_transform.basis.x
		
	velocity = lerp(velocity,direction.normalized() * current_speed, acceleration)
	
	if Input.is_action_pressed("jump") and y_velocity.y > 0:
		gravity = max_gravity * gravity_alt_perectage
	else:
		gravity = max_gravity
	
	if not is_on_floor():
		acceleration = 0.03
		y_velocity.y -= gravity * delta
	else:
		acceleration = 0.9
		feet_col_shape.disabled = true
		y_velocity.y = -0.1
	
	if is_on_ceiling():
		y_velocity.y = -1
	
	#snap to floor
	var SNAP = -get_floor_normal()
	
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SNAP = Vector3.ZERO
		feet_col_shape.disabled = false
		y_velocity.y = jump_velocity
		
	var stop_on_slope = true if get_floor_velocity().length() == 0 else false
	#############
	move_and_slide_with_snap(velocity+y_velocity+get_floor_velocity(),SNAP, Vector3.UP, stop_on_slope)
	
	updateCamera(delta)
	
	if Input.is_action_just_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#rotation
	
	target_rotation = lerp(target_rotation, global_transform.origin + velocity, 0.2)
	target_rotation.y = global_transform.origin.y
	if velocity.length() > 0.4:
		look_at(target_rotation,Vector3.UP)
	
	if Input.is_action_just_pressed("attack"):
		attack()
	animate()
	update_interaction()
	
func attack():
	if attack_step == 0:
		animator.set("parameters/attack1/active",true)
		attack_step = 1
		return
	
	if attack_step != 0:
		if combo_possible:
			combo_possible = false
			attack_step += 1
		

func combo():
	if attack_step == 2:
		animator.set("parameters/attack1/active",false)
		animator.set("parameters/attack2/active",true)
	if attack_step == 3:
		animator.set("parameters/attack2/active",false)
		animator.set("parameters/attack3/active",true)

		
func combo_possible():
	combo_possible = true
	

func combo_reset():
	combo_possible = false
	attack_step = 0


func updateCamera(delta):
	camera.global_transform.origin = global_transform.origin
	camera.rotation_degrees.y -= mouse_input.x * mouse_sensitivity * delta
	camera_v.rotation_degrees.x -= mouse_input.y * mouse_sensitivity * delta
	
	camera_v.rotation_degrees.x = clamp(camera_v.rotation_degrees.x,-90,90)
	
	mouse_input = Vector3.ZERO
	
	

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		get_tree().reload_current_scene()


func animate():
	
	if not is_on_floor():
		animator.set("parameters/grounded_state/current",1)
	else:
		animator.set("parameters/grounded_state/current",0)
	
	if velocity.length() > 0.5:
		animator.set("parameters/move_state/blend_position",1)
	else:
		animator.set("parameters/move_state/blend_position", 0)


func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative


func _on_stump_area_body_entered(body):
	if body.is_in_group("enemies"):
		y_velocity.y = jump_velocity
		body.take_damage(1)

#called in attack animations
func disable_attack_shape(disabled:bool):
	attack_area_shape.disabled = disabled

func _on_Attack_area_body_entered(body):
	if body.is_in_group("enemies"):
		y_velocity.y = jump_velocity
		body.take_damage(1)


func _on_interact_area_area_entered(area):
	if area.name == "gate_area":
		UI.show_gate_info(true)

func _on_interact_area_area_exited(area):
	if area.name == "gate_area":
		UI.show_gate_info(false)



func update_interaction():
	if $interact_area/CollisionShape.disabled == false:
		$interact_area/CollisionShape.disabled = true
	if Input.is_action_just_pressed("interact"):
		$interact_area/CollisionShape.disabled = false


func _on_interact_area_body_entered(body):
	if body.is_in_group("NPC"):
		body.start_dialog()
	elif body.is_in_group("level_gate"):
		body.start_level_request_dialog()








