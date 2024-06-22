extends Area2D

var key = 0
var speed = 0
var canHit = false
var hited = false
var work = false

func _process(delta):
	self.position.y += speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	if work:
		self.queue_free()

func _input(event):
	if canHit:
		if key==1:
			if Input.is_action_just_pressed("hit1"):
				hited = true
		elif key==2:
			if Input.is_action_just_pressed("hit2"):
				hited = true
		if key==3:
			if Input.is_action_just_pressed("hit3"):
				hited = true
		elif key==4:
			if Input.is_action_just_pressed("hit4"):
				hited = true
		if key==5:
			if Input.is_action_just_pressed("hit5"):
				hited = true
		elif key==6:
			if Input.is_action_just_pressed("hit6"):
				hited = true
		if key==7:
			if Input.is_action_just_pressed("hit7"):
				hited = true
		elif key==8:
			if Input.is_action_just_pressed("hit8"):
				hited = true
	if hited:
		$Sprite2D.visible = false
		$CPUParticles2D.emitting = true

func _on_visible_on_screen_enabler_2d_screen_entered():
	pass
