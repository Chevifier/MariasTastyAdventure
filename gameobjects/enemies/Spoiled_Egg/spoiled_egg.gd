extends Enemy

onready var animator = $spoiled_egg/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if state == EnemyState.IDLE and in_range(15):
		state = EnemyState.MOVING
	
	if state == EnemyState.MOVING:
		direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0
		velocity = direction * speed 
		
		rotate_to_target(global_transform.origin+velocity,true)
	
	if not is_on_floor():
		y_velocity.y -= gravity * delta
	else:
		y_velocity.y = -0.1
		
	
	if state == EnemyState.ATTACKING:
		velocity = Vector3.ZERO
	
	
	velocity = move_and_slide(velocity+y_velocity, Vector3.UP)
	animate()
	
func animate():
	match(state):
		EnemyState.IDLE:
			animator.play("idle")
		EnemyState.MOVING:
			animator.play("running")
		EnemyState.ATTACKING:
			animator.play("charging_exp")


func _on_Area_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
		state = EnemyState.ATTACKING
		$Area/CollisionShape.disabled = true
		$ExplodeTimer.start(3)


func _on_Timer_timeout():
	$explosion_Area/CollisionShape.disabled = false
	$Remove_Timer.start()



func _on_explosion_Area_body_entered(body):
	if body.name == "Player":
		body.take_damage(2)


func _on_Remove_Timer_timeout():
	queue_free()
