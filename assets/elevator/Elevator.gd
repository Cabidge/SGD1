tool
extends Node2D

const CABIN_TOP = -64
const CABIN_BOT = 24

export var door_open := false setget set_door_open, get_door_open
export var player_visible := true setget set_player_visible, get_player_visible
export var enable_camera := false setget set_camera_enabled, get_camera_enabled

onready var cabin = $Cabin
onready var cabin_tween = cabin.get_node("Tween")
onready var player = $Cabin/Player
onready var player_tween = player.get_node("Tween")

onready var door = $Door

onready var door_audio = $DoorAudio

func set_door_open(new : bool):
	$Door.is_open = new

func get_door_open():
	return $Door.is_open

func open_door():
	door.open()

func close_door():
	door_audio.play()
	door.close()


func set_player_visible(new):
	$Cabin/Player.visible = new

func get_player_visible():
	return $Cabin/Player.visible

func tween_player_sprite(player_sprite : AnimatedSprite):
	player.flip_h = player_sprite.flip_h
	var sprite_pos = player_sprite.global_position - cabin.global_position
	
	cabin_tween.interpolate_property(player,"position",sprite_pos,\
			Vector2(0,6),0.4,Tween.TRANS_QUAD,Tween.EASE_OUT)
	cabin_tween.start()
	player.position = sprite_pos
	$Cabin/Player/Camera2D.align()
	
	set_player_visible(true)


func set_camera_enabled(new):
	$Cabin/Player/Camera2D.current = new

func get_camera_enabled():
	return $Cabin/Player/Camera2D.current


func tween_cabin(from_y : float, to_y : float):
	player_tween.interpolate_property(cabin,"position",Vector2(0,from_y),Vector2(0,to_y),1.6,\
			Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	player_tween.start()

func cabin_bot_up():
	door_audio.play()
	tween_cabin(CABIN_BOT,-24)

func cabin_mid_up():
	tween_cabin(-24,CABIN_TOP)
