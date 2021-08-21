extends KinematicBody
class_name Enemy

export var health = 2
export var speed = 6
export var attack_speed = 9
var direction = Vector3()
var velocity = Vector3()
var target_rotation = Vector3()
var y_velocity = Vector3()
var gravity = 19.78
onready var player = get_parent().get_node("Player")

enum EnemyState{
	IDLE,
	ALERTED,
	MOVING,
	ATTACKING,
	DIE
}
var state

func _ready():
	add_to_group("enemies")
	state = EnemyState.IDLE

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
	
func can_see_player():
	var player_visible = false
	var start_point = global_transform.origin
	var end_point = player.global_transform.origin
	var world_space = get_world().direct_space_state
	var ray_result = world_space.intersect_ray(start_point,end_point,[self])
	if ray_result.size() > 0:
		if ray_result.collider.name == "Player":
			player_visible = true
	return player_visible
	
func in_range(distance):
	return global_transform.origin.distance_to(player.global_transform.origin) < distance
	
	
func rotate_to_target(target:Vector3, lock_y_rotation: bool):
	#rotation
	target_rotation = lerp(target_rotation, target, 0.2)
	if lock_y_rotation:
		target_rotation.y = global_transform.origin.y
	if velocity.length() > 0.1:
		look_at(target_rotation,Vector3.UP)
