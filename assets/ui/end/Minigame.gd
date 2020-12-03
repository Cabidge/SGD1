extends Control

signal completed
signal arrows_cleared

var arrows_texture = load("res://assets/ui/end/arrows.png")
var arrow_nums = []

var active = false

onready var begin_button = $Begin
onready var begin_audio = $BeginAudio

onready var arrow_container = $CenterContainer/ArrowContainer

onready var click_audio = $ClickAudio

onready var timer = $Timer
onready var time_progress = $TimeProgress

onready var loading = $Loading
onready var check = $Check

onready var success_audio = $SuccessAudio

func _ready():
	set_process_unhandled_input(false)
	time_progress.max_value = timer.wait_time

func _process(delta):
	time_progress.value = timer.time_left

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		arrow_pressed(0)
	elif event.is_action_pressed("ui_right"):
		arrow_pressed(1)
	elif event.is_action_pressed("ui_down"):
		arrow_pressed(2)
	elif event.is_action_pressed("ui_left"):
		arrow_pressed(3)


func start():
	if active: return
	active = true
	
	time_progress.visible = true
	
	set_process_unhandled_input(true)
	
	for i in [2,2,2,2,3,3,3,4,4,5,6]:
		add_arrows(i)
		timer.start()
		yield(self,"arrows_cleared")
		if !active:
			return
	
	timer.stop()
	time_progress.visible = false
	
	loading.visible = true
	
	yield(get_tree().create_timer(1.2),"timeout")
	
	loading.visible = false
	check.visible = true
	success_audio.play()
	
	yield(get_tree().create_timer(1),"timeout")
	
	emit_signal("completed")
	
	active = false
	set_process_unhandled_input(false)

func _on_Begin_pressed():
	begin_audio.play()
	begin_button.visible = false
	start()


func reset():
	active = false
	
	begin_button.visible = true
	time_progress.visible = false
	
	for arrow in arrow_container.get_children():
		arrow.queue_free()
	arrow_nums = []
	emit_signal("arrows_cleared")

func _on_Timer_timeout():
	reset()


func add_arrows(num : int):
	for i in num:
		num = randi() % 4
		arrow_nums.append(num)
		var arrow = create_arrow(num)
		arrow_container.add_child(arrow)

func arrow_pressed(num : int):
	if arrow_nums.size() == 0:
		return
	
	if arrow_nums[0] == num:
		click_audio.play()
		arrow_nums.remove(0)
		arrow_container.get_child(0).queue_free()
		if arrow_nums.size() == 0:
			emit_signal("arrows_cleared")


func get_arrow_texture(frame = 0):
	var texture = AtlasTexture.new()
	texture.atlas = arrows_texture
	texture.region.size = Vector2.ONE * 20
	texture.region.position.x = frame * 20
	return texture

func create_arrow(frame = 0):
	var texture = get_arrow_texture(frame)
	var arrow = TextureRect.new()
	arrow.texture = texture
	arrow.rect_pivot_offset = Vector2.ONE * 10
	return arrow
