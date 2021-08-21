extends Enemy

var idle_position = Vector3()
export var monitor_attack_range = 20
var attacking = false

func _ready():
	health = 10000
	idle_position = global_transform.origin

func _physics_process(delta):
	if not is_on_floor() and in_range(monitor_attack_range) and state == EnemyState.IDLE:
		attack()
	elif is_on_floor() and state == EnemyState.ATTACKING:
		$Reset_Timer.start()
		state = EnemyState.ALERTED
		
	#complete reset
	if global_transform.origin.distance_to(idle_position) < 0.2 and state == EnemyState.MOVING:
		state = EnemyState.IDLE
		velocity = Vector3.ZERO
	
	velocity = move_and_slide(velocity, Vector3.UP)
		
func attack():
	#attacking = true
	state = EnemyState.ATTACKING
	velocity = Vector3.DOWN  * attack_speed
func reset():
	#move back to original_position
	state = EnemyState.MOVING
	direction = idle_position - global_transform.origin
	velocity = direction.normalized() * speed


func _on_Area_body_entered(body):
	if body.name == "Player":
		body.take_damage(3)
	
	


func _on_Reset_Timer_timeout():
	reset()
