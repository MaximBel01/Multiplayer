extends CharacterBody2D


const SPEED = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction:Vector2
func _ready():
	direction=Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	velocity = SPEED*direction
	if not is_on_floor():
		velocity.y += gravity*1 * delta
	if get_slide_collision_count()>0:
		queue_free()

	

	move_and_slide()
