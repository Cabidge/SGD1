extends RichTextLabel

signal finished

const CHAR_PER_SEC = 8

onready var timer = $Timer
onready var text_audio = $TextAudio

func _ready():
	timer.wait_time = 1.0 / CHAR_PER_SEC


func scroll_text(txt: String, newline = false):
	if newline:
		visible_characters = 0
		bbcode_text = txt
	else:
		visible_characters = get_total_character_count()
		bbcode_text += "\n" + txt
	timer.start()

func _on_Timer_timeout():
	if get_total_character_count() > visible_characters:
		next_char()
		timer.start()
	else:
		finish()

func next_char():
	var this_char = text.replace("\n","")[visible_characters]
	visible_characters += 1
	if this_char == " " and visible_characters + 1 < get_total_character_count():
		next_char()
	else:
		text_audio.play()

func finish():
	timer.stop()
	emit_signal("finished")
	visible_characters = -1


func is_scrolling() -> bool:
	return !timer.is_stopped()
