extends KinematicBody2D

# vector to determine character motion
var motion = Vector2()
# direction gravity is pulling
var gravDirection

# determines which way is up for purpose of floors/ceilings/walls
const UP = Vector2.UP
# acceleration of gravity
const GRAVITY = 20
# constants for direction of gravity
const GRAV_RIGHT = 3
const GRAV_DOWN = 0
const GRAV_LEFT = 1
const GRAV_UP = 2

export(AudioStreamRandomPitch) var landingNoise

# Called when the node enters the scene tree for the first time.
func _ready():
	gravDirection = GRAV_DOWN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# determine input and shift gravity accordingly
	if Input.is_action_pressed("ui_right"):
		gravDirection = GRAV_RIGHT # set gravDirection rightward
	elif Input.is_action_pressed("ui_down"):
		gravDirection = GRAV_DOWN # set gravDirection downward
	elif Input.is_action_pressed("ui_left"):
		gravDirection = GRAV_LEFT # set gravDirection leftward
	elif Input.is_action_pressed("ui_up"):
		gravDirection = GRAV_UP # set gravDirection upward
	
	# apply gravity and animate
	shiftGravity(gravDirection) # apply gravity
	animateFall(gravDirection) # animate sprite depending on direction of gravity
	
	# apply motion
	motion = move_and_slide(motion, UP)

func shiftGravity(direction:int = GRAV_DOWN):
	match direction:
		GRAV_RIGHT: # RIGHT
			motion.x += GRAVITY # apply gravity rightwards
			return
		GRAV_DOWN: # DOWN
			motion.y += GRAVITY # apply gravity upwards
			return
		GRAV_LEFT: # LEFT
			motion.x -= GRAVITY # apply gravity leftwards
			return
		GRAV_UP: # UP
			motion.y -= GRAVITY # apply gravity upwards
			return

func animateFall(direction:int = GRAV_DOWN):
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		if $Sprite.frame == 1:
			$AudioStreamPlayer2D.set_stream(landingNoise)
			$AudioStreamPlayer2D.play()
		$Sprite.frame = 0 # play idle anim
		return
	# play falling anim
	set_rotation_degrees(90*direction) # 0 for down, 90 for left, 180 for up, 270 for right
	$Sprite.frame = 1 # play falling anim
