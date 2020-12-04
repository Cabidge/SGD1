extends Control

signal continued
signal ended

var lines = [ # format: ["text" : String, is_newline : bool]
	[ # before hacking:
		["[center][October 5th, 1:43 AM]",true],
		["I've arrived at the destination.", true],
		["Good work.",true],
		["Do you have the dirt?",false],
		["Not yet.",true],
		["There's a password.",false],
		["Heavy encryption too.",false],
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
		["I'm in.", true],
		["Really?",true],
		["Nice job.", false],
		["I'm sending the files over right now.", true],
		["I'll be sure to provide adequate compensation.",true],
		["...",true],
		["...",false],
		["Alright, that should be all of it.",false],
		["Yup, got 'em.",true],
		["Pleasure doin' business with ya.",false],
		["Likewise.",true],
		["[center][End of Call]",true],
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

onready var window_anim = $Window/AnimationPlayer

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
	
	line_index = 0
	page += 1
	
	while scroll_next_line():
		waiting = true
		yield(self,"continued")
	
	scroll.bbcode_text = ""
	advance_arrow.visible = false
	
	window_anim.play("Close")
	
	yield(window_anim,"animation_finished")
	
	lines.append(generate_report())
	
	line_index = 0
	page += 1
	
	while scroll_next_line():
		waiting = true
		yield(self,"continued")
	
	advance_arrow.visible = false
	
	yield(get_tree().create_timer(1.2),"timeout")
	
	emit_signal("ended")

func scroll_next_line() -> bool:
	if lines[page].size() <= line_index:
		return false
	
	advance_arrow.visible = false
	
	var line = lines[page][line_index]
	scroll.scroll_text(line[0],line[1])
	
	line_index += 1
	
	return true

func generate_report():
	var progress_report_lines = [
		["[center][Progress Report]",true],
	]
	var total_spotted = 0
	for i in Player.scores.size():
		var level_number = ["[center]Floor " + str(i + 1) + ":",true]
		var spotted = Player.scores[i]
		total_spotted += spotted
		var score = [Player.get_score(spotted),false]
		progress_report_lines.append(level_number)
		progress_report_lines.append(score)
	
	var combined = ceil(float(total_spotted) / Player.scores.size())
	progress_report_lines.append(["[center]Combined Stealth Score:",true])
	progress_report_lines.append([Player.get_score(combined),false])
	
	return progress_report_lines


func _on_ScrollingText_finished():
	advance_arrow.visible = true
