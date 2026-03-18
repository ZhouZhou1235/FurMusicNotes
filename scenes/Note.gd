# 音符节拍点
# 在判定区域内可消除

extends RigidBody2D

# hitKey消除键 go是否落下 isLong是否长音
var mySpeed :int
var hitKey :int
var long: float
var go :bool = false
var isLong: bool = false
var needHit :bool = false
var canHit :bool
var hit :bool

# 设置并开始
func setAndGo(speed,key,l,need):
	# 屏幕大小 1280x720
	# 所以hit1的位置是144 间隔128
	var hit1posx = 144
	var shiftNum = 128
	mySpeed = speed
	hitKey = key
	long = l
	needHit = need
	if long!=0:
		isLong = true
		$Appearance.width *= speed/100
		$Appearance.default_color = Color("96c8fac8")
	if !needHit:
		$Appearance.default_color = Color("af98d396")
	self.position = Vector2(hit1posx+(hitKey-1)*shiftNum,-16)
	go = true

# 帧中监听消除操作
func listenHit():
	if canHit:
		if !isLong:
			if Input.is_action_just_pressed("hit1") and hitKey==1: hitNote()
			if Input.is_action_just_pressed("hit2") and hitKey==2: hitNote()
			if Input.is_action_just_pressed("hit3") and hitKey==3: hitNote()
			if Input.is_action_just_pressed("hit4") and hitKey==4: hitNote()
			if Input.is_action_just_pressed("hit5") and hitKey==5: hitNote()
			if Input.is_action_just_pressed("hit6") and hitKey==6: hitNote()
			if Input.is_action_just_pressed("hit7") and hitKey==7: hitNote()
			if Input.is_action_just_pressed("hit8") and hitKey==8: hitNote()
		else:
			if Input.is_action_pressed("hit1") and hitKey==1: hitNote()
			if Input.is_action_pressed("hit2") and hitKey==2: hitNote()
			if Input.is_action_pressed("hit3") and hitKey==3: hitNote()
			if Input.is_action_pressed("hit4") and hitKey==4: hitNote()
			if Input.is_action_pressed("hit5") and hitKey==5: hitNote()
			if Input.is_action_pressed("hit6") and hitKey==6: hitNote()
			if Input.is_action_pressed("hit7") and hitKey==7: hitNote()
			if Input.is_action_pressed("hit8") and hitKey==8: hitNote()

# 击中音符
func hitNote():
	if needHit:
		var accuracy :int
		hit = true
		$Appearance.hide()
		if isLong:
			$Particle.color = Color("96c8fac8")
		$Particle.emitting = true
		mySpeed = 0
		if !isLong:
			$Accuracy.show()
			var deviation = abs(self.position.y-576)
			var num = 16
			if deviation<=num:
				accuracy = 1
				$Accuracy.text = "精准"
				$Animate.play("accuracy_best")
			elif deviation<=num*2:
				accuracy = 2
				$Accuracy.text = "很棒"
				$Animate.play("accuracy_great")
			elif deviation<=num*3:
				accuracy = 3
				$Accuracy.text = "不错"
				$Animate.play("accuracy_good")
			else:
				accuracy = 4
				$Accuracy.text = "一般"
				$Animate.play("accuracy_ok")
			# 获取Play节点
			var Play = self.get_parent().get_parent()
			Play.addCount(accuracy)
	else:
		$Appearance.hide()
		$Particle.color = Color("af98d396")
		$Particle.emitting = true
		mySpeed = 0

func _ready():
	canHit = false
	hit = false
	$Accuracy.hide()
	$Accuracy.text = ""

func _process(delta):
	if go:
		self.position.y += mySpeed*delta
		listenHit()

func _on_visible_rect_screen_exited(): self.queue_free()

func _on_particle_finished(): self.queue_free()
