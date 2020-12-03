extends Control

signal continued

var lines = [ # format: ["text" : String, is_newline : bool]
	[ # before hacking:
		["I've arrived at the destination.", true],
		["Good work.",true],
		["Have you found the dirt?",false],
		["Not yet.",true],
		["There's a password on it.",false],
		["It's heavily encrypted too.",false],
		["Do you think you can bypass it?",true],
		["It may take a while...",true],
		["But my [shake]l33t h4x0ring skillz[/shake] should be able to handle it.",false],
		["...",true],
		["What's wrong?",true],
		["Nevermind.",true],
		["You can do it right?",false],
		["Just get it done.",false],
		["Roger that.",true]
	],
	[ # after hacking:
		["*Hacker Voice* I'm in.", true],
		["Really?",true],
		["Nice job.", false],
		["I'm sending the files over to you right now.", true],
		["I'll be sure to provide adequate compensation.",true],
		["...",true],
		["...",false],
		["Alright, that should be all of the files.",false],
		["...Yup, I got 'em.",true],
		["Wow...this'll be real useful.",false],
		["Pleasure doin' business with ya.",true],
		["Likewise.",true],
	]
]

var page = 0
var line_index = 0

var started = false
var waiting = false

onready var scroll = $ScrollingText
onready var advance_arrow = $Advance

onready var advance_audio = $AdvanceAudio

onready var minigame = $Minigame
onready var minigame_anim = minigame.get_node("AnimationPlayer")

func _input(event):
	if started and waiting and event.is_action_pressed("advance_text"):
		if scroll.is_scrolling():
			scroll.finish()
		else:
			advance_audio.play()
			waiting = false
			emit_signal("continued")

func start():
	if started: return
	started = true
	
	while scroll_next_line():
		waiting = true
		yield(self,"continued")
	
	scroll.bbcode_text = ""
	advance_arrow.visible = false
	
	minigame_anim.play("Show")
	yield(minigame,"completed")
	minigame_anim.play_backwards("Show")
	
	page += 1
	
	while scroll_next_line():
		waiting = true
		yield(self,"continued")
	
	print("finished")
	
	scroll.bbcode_text = ""
	advance_arrow.visible = false

func scroll_next_line() -> bool:
	if lines[page].size() <= line_index:
		return false
	
	advance_arrow.visible = false
	
	var line = lines[page][line_index]
	scroll.scroll_text(line[0],line[1])
	
	line_index += 1
	
	return true


func _on_ScrollingText_finished():
	advance_arrow.visible = true
