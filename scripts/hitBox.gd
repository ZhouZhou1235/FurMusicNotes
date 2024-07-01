extends RigidBody2D

var hitBoxSpeed = 500
var canHit = false
var mouseCanHit = false
var hited = false
var key :int
var duration = 0

func exactShow():
	$body/exactParticles.emitting = true

func _ready():
	var osName = OS.get_name()
	if osName!="Windows" and osName!="Linux":$mouseHit.show()
	
func _process(delta):
	self.position.y += hitBoxSpeed*delta

func _input(event):
	if GlobalArea.levelPlay and canHit:
		if Input.is_action_just_pressed("hit1") and key==1:
			hited = true
		if Input.is_action_just_pressed("hit2") and key==2:
			hited = true
		if Input.is_action_just_pressed("hit3") and key==3:
			hited = true
		if Input.is_action_just_pressed("hit4") and key==4:
			hited = true
		if Input.is_action_just_pressed("hit5") and key==5:
			hited = true
		if Input.is_action_just_pressed("hit6") and key==6:
			hited = true
		if Input.is_action_just_pressed("hit7") and key==7:
			hited = true
		if Input.is_action_just_pressed("hit8") and key==8:
			hited = true
		#if event is InputEventMouseButton:
			#if event.button_index==MOUSE_BUTTON_LEFT and canHit and mouseCanHit:
				#if event.is_pressed():
					#hited = true
	if hited:
		$body/CPUParticles2D.emitting = true
		$body/appearance.hide()

func _on_cpu_particles_2d_finished():
	self.queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	self.queue_free()

func _on_mouse_hit_button_down():
	if canHit:
		hited = true
